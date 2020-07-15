#  IntoTheWild - Automating with Geofences

Chapter 3 of Build Location-Based Projects for iOS

In this chapter we will use such a “magic” trigger to execute our code. We will
build an app that measures how long the users are outside each day without
the need for any user interaction. The app will register when the users leave
the house and when they come back, and it will show a chart of the hours
they spend outside each day.

The "magic" trigger we will use is geofences. A geofence is a region on a map
that is coupled with an automatic action that is executed when the device
with the geofence enters or exits the region. In iOS, geofences are one of the
few supported ways to execute code when the app in question is not running.
When the device with our app enters or exists the registered region, our app
is launched in the background and can then execute code for a few seconds
before it is terminated again.

This project uses the LogStore package covered in the appendix of this book.
An improved version is used in this project available at [LogStore](https://github.com/sargapman/LogStore)

