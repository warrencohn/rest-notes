## Authentication and account management ##

There are a few ways to do authentication using REST. I opted for a sessionless model, using HTTP basic authentication over SSL. Not having to deal with sessions and their expiration times in nice when using REST applications, as the clients may be used in very different scenarios. This way, clients can be very simple, without the added complexity of keeping and renewing a session ID.

On the iPhone side, I'm using the HTTPRiot library to handle REST communication. This library supports https connections and basic auth. However I had to change it in order to support invalid SSL certificates, which are frequent in developer machines. Although I didn't implement it, this option should be turned off for production apps, as you don't want your app to connect to some man-in-middle attacker, defeating the purpose of SSL.

The WO side is more interesting. First, I wanted to have a simple way to know what user had authenticated. So, I created the [GenericController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/GenericController.java) class, and made all other controllers inherit from it. The `initAuthentication` method is called on the controller constructor, and will handle all the authentication process, resulting in storing the authenticated user in the `authenticatedUser` instance var is the authentication succeeds.

Next, I want a different behavior in [UserController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/UserController.java)  and [NoteController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/NoteController.java). I want that all the methods in `NoteController` can only be run by authenticated users. On `UserController`, the `createAction` method must be run without an authenticated user, because we are registering a new user there. So, authentication is handled on a case-by-case fashion in `UserController`. `NoteController`, however, uses the following method:

```
@Override
protected void checkAccess() throws SecurityException {
    if( authenticatedUser() == null ) {
        throw new SecurityException();
    }
    super.checkAccess();
}
```

This will end up throwing a 403 Forbidden HTTP error code to the client. In this case, the iPhone will show a "wrong user or password" alert. The interesting part is that this validation will apply to all the methods on this controller, so there's no danger of "forgetting" to authenticate any action. If you have several controllers that need authentication for all actions, you can create another abstract controller in the hierarchy (say, `AuthenticatedController`) and include the `checkAccess` method there. This way you don't have to worry about it any more.

Of course, you still need to verify is the objects the user is trying to view or modify belong to him. There's not a very "magical" way to do that, but you should be able to do that with simple verifications on most cases, like:

```
@Override
public WOActionResults updateAction() throws Throwable {
    Note note = note();
    if( note.user() != authenticatedUser() ) {
        return errorPageForStatusAndMessage( WOMessage.HTTP_STATUS_FORBIDDEN, null );
    }
    update( note, ERXKeyFilter.filterWithAttributes() );
    editingContext().saveChanges();
    return response( note, ERXKeyFilter.filterWithAll() );
}
```

## Non-standard actions ##

REST applications usually expose resources using the typical set of actions (update, delete, show, etc). Of course, REST is all about flexibility, so you can add any kind of actions you want. ERRest has an awesome way to do this and map those actions to an URL.

You can see this in two places of the WO app. Check [NoteController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/NoteController.java) and [UserController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/UserController.java) classes for the randomAction and loginAction methods.

As an example, here is the randomAction method:

```
@GET
@Path("/note/random")
public WOActionResults randomAction() throws Throwable {
    Note note = Note.randomNote( editingContext() );
    note.setUserRelationship( authenticatedUser() );
    editingContext().saveChanges();
    return response( note, ERXKeyFilter.filterWithAll() );
}
```

The `@GET` tag tells this action is available if the client uses the HTTP GET method to access it. `@Path` tells ERRest what is the URL you want to map this action to.

## Exposing different keys according to context ##

It's sometimes handy to expose different keys of an object in different situations, including keys whose value is generated on-the-fly, and is not mapped to a data storage column. There's an example of that in the [NoteController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/NoteController.java) class. The `indexAction` will expose the note creation date and a `contentPreview` key, which is a cropped version of the note content. This is enough for the notes table. When the user taps a note, the `showAction` method will be called exposing the full content of the note. [UserController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/UserController.java) uses the same technique for avoiding exposing the user's password hash.

## Error handling ##

Just like authentication, there's plenty of techniques to report errors on REST APIs. REST Notes returns errors to the client by setting the response code to 500 (internal server error) and adding a custom header (`X-Restnotes-Error`) to the response. Error reporting was done this way because HTTPRiot will not receive and process the request body if it detects and error on the header. This way, it's very easy to handle the error on the iPhone side, and display an alert with a customized message. On the server, this is handled by the `errorPageForStatusAndMessage` method in the [GenericController](http://code.google.com/p/rest-notes/source/browse/trunk/WO/Sources/net/terminalapp/notes/rest/controllers/GenericController.java).