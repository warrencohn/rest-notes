# Introduction #

REST Notes is a sample notes app. Notes are stored on a server, and exposed trough an WebObjects application using the ERRest framework. The iPhone application uses the exposed REST API to create users, login, create, read, edit and delete notes.

Please take into consideration this is NOT supposed to be a final product. The interface is ugly, there may be a few bugs, and some stuff isn't as optimized as it can be. I wrote this simply to get the feeling of how to correctly write REST stuff, and make it available for the community.

Requirements for you to compile and run this app are:
  * WebObjects 5.3.3 or newer
  * Wonder frameworks (including ERRest). I'm using SVN [revision 10908](https://code.google.com/p/rest-notes/source/detail?r=10908), anything newer than that should work fine.
  * XCode 3.2.4 with iPhone SDK 4.1 installed. You need to have an active developer license if you want to run the app on your physical device. Anyway, the simulator should do just fine.

Now to the important stuff:
  * [How to configure, compile and run REST Notes](InstallationInstructions.md). Read this, because you need to make some changes for your environment.
  * [Solutions used to some of the common problems](LecturePage.md) like authentication or error handling, and [some notes on the iPhone client architecture](ClientArchitecture.md) you can re-use in your applications.