#  IntoTheWild - Automating with Geofences

### Chapter 3 of Build Location-Based Projects for iOS

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

### How to use this app

This app initially presents a simple UI with a single button: Set Home.  Tapping this button sets the current location as Home.
The app then sets up a geofence region centered on that location with a radius of 10 meters.  The app records every exit and re-entry of the iPhone to that geofenced area.  At the end of every day it calculates the total time outside of the geofenced area and presents that in a bar chart that includes the last 7 days of activity.
