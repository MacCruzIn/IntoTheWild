//
//  ContentView.swift
//  IntoTheWild
//
//  Created by Monty Boyer on 7/12/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var locationProvider: LocationProvider
    
    var body: some View {
        VStack {
            Text("Into The Wild")
            Button("Set Home") {
                self.locationProvider.setHome()
            }
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(self.locationProvider.dayEntries, id: \.self) { value in
                    DayEntryView(duration: value.duration, max: self.locationProvider.max, weekday: value.weekday)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))    // works well in light & dark mode
        // present alert if not properly authorized
        .alert(isPresented: $locationProvider.wrongAuthorization) {
            Alert(title: Text("Not authorized"),
                  message: Text("Open Settings and authorize this app."),
                  primaryButton: .default(Text("Settings"), action: {
                    // open the Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                  }),
                  secondaryButton: .default(Text("Ok")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    // create 7 days of example data
    static var locationProvider: LocationProvider = {
        let locationProvider = LocationProvider()
        locationProvider.dayEntries = [
            DayEntry(duration: 20640, weekday: "Monday"),
            DayEntry(duration: 2580, weekday: "Tuesday"),
            DayEntry(duration: 12000, weekday: "Wednesday"),
            DayEntry(duration: 1200, weekday: "Thursday"),
            DayEntry(duration: 2200, weekday: "Friday"),
            DayEntry(duration: 19920, weekday: "Saturday"),
            DayEntry(duration: 18000, weekday: "Sunday")
        ]
        return locationProvider
    }()
    
    static var previews: some View {
        // previews for light & dark modes
        Group {
            ContentView()
                .environmentObject(locationProvider)
            ContentView()
                .environmentObject(locationProvider)
                .environment(\.colorScheme, .dark)
        }
    }
}
