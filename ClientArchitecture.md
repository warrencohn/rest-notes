The iPhone client includes the [HTTPRiot library](https://github.com/ognen/httpriot/tree) to handle the HTTP communication and result parsing. The source code of HTTPRiot itself was included, so that it can be easily changed.

HTTPRiot architecture is a little crazy IMO. Usage is essentially based on a class, `HRRestModel`, which is used trough a bunch of static methods. This makes it a little hard to have different delegates and selectors to be called for different requests.

To solve this, `HRRestModel` has been subclassed into a [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) class, which contains some of the mechanics that are used by the application. [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m), together with the [RESTOperationWrapper](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/RESTOperationWrapper.m) wrapper class, introduces some flexibility on this, allowing for customized delegates and selectors. Also,  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) provides default behavior for error management which can be tuned in any of the individual communication operations.

To perform the actual communication,  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) is subclassed into specific connectors. In this application case, those are [NoteConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/NoteConnector.m) and [UserConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/UserConnector.m). This classes contain the code to fetch from or send information to the server. Here are two examples:

```
+ (void) fetchAllNotes: (id) delegate withCallback: (SEL) theSelector {
    [self getPath:@"/notes.json" withOptions:nil object:[RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector]];
}
```

This method requests all the notes from the server for the logged in user (whose user and passwords have previously been set as static properties of the class). The delegate and callback selector are wrapped in a [RESTOperationWrapper](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/RESTOperationWrapper.m) instance, which is used to track the request among the  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) and `HRRestModel` machinery.  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) automatically identifies the result as being an array, and finds a "Note" class that can be used to deserialize the result. So, `theSelector` will automatically receive an `NSArray` of `Note` instances. Read the  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) code to understand how does this work. The code is short, but interesting. :)

```
+ (void) createUser: (User*) user delegate: (id) delegate callback: (SEL) theSelector errorCallback: (SEL) errorSelector {
    NSString *json = [[user dictionaryForSerialization] JSONRepresentation];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:json forKey:@"body"];
    RESTOperationWrapper *wrapper = [RESTOperationWrapper wrapperForDelegate:delegate andSelector:theSelector];
    [wrapper addErrorHandler:errorSelector forCode:500];
    [self postPath:@"/users.json" withOptions:opts object:wrapper];
}
```

This method is used to register a new user in the system. As the user must be uploaded in the request body, it's first serialized and then including in the options dictionary as the body of the request. An important detail here is the `errorSelector`. This is used to tell  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) we want to handle the 500 HTTP error in a customized way. The server will report a 500 error in the case where someone tries to register a new user with an already used username. So, instead of the generic error, we want to display the comprehensive error message reported by the server, which is done by the `errorSelector` passed into this method. This could also tweak the user interface (like selecting the text in the username field, so the user can edit it and try again).

The automatic deserialization is done based on the type reported by the server. Every object ERRest serializes in JSON includes a "type" key with the entity name as its value.  [GenericConnector](http://code.google.com/p/rest-notes/source/browse/trunk/iOS/Classes/GenericConnector.m) will look for any class with the same name that responds to the `initWithDictionary:` method. If it finds a proper class, an instance is allocated and `initWithDictionary:` is called with all the values in the dictionary. Serialization is always done manually, but it's recommended that serializable classes have a common way to obtain a serialized dictionary. This is done using the `dictionaryForSerialization` method in this application.