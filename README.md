# RemoteNotificationUITests

This is a little demo projects that tests Remote Notification handling using Xcode UITests. For details checkout this blogpost: http://www.pixeldock.com/blog/testing-push-notifications-with-xcode-uitests/

To make this demo work on your machine follow these steps:

1. Clone the project
2. Add the project as a new app to your developer account (don't forget to change the appID inside the project)
3. Create a APN development certificate for this new app, download it and add it to your Keychain
4. Export the certificate as "pusher.p12" (use the password "pusher")
5. Add the p12 file to the project UITest target

That should be it.

Here is a video of the test in action: https://youtu.be/Nl97SBXk7bU
