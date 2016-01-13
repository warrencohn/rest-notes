## WO Side ##

  1. Import the project into Eclipse.
  1. Run the app and stop it to create a run configuration. To do that, right-click on the Application class and choose Run as > WOApplication.
  1. Edit the run configuration and set a fixed WOPort for the application. This is convenient for having a fixed URL the iPhone can connect to.

## iPhone side ##

Here, you just need to open the XCode project and edit the RESTNotes-Info.plist file. Locate the NotesURL entry, and adjust the URL to your installation. Make sure the URL ends with "`/ra`". Note that you may use https (assuming you configured apache correctly) even if your local SSL certificate is invalid.

That's it, you should now be able to run both apps and use REST Notes.