//
//  DayEntriesCalculator.swift
//  IntoTheWild
//
//  Created by Monty Boyer on 7/12/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import Foundation

struct DayEntriesCalculator {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // just get the weekday name
        return formatter
    }()
    
    // find the combined duration within the region for the given date
    static func durationFor(date: Date, from regionUpdates: [RegionUpdate]) -> TimeInterval {
        var duration = 0.0
        var enter: RegionUpdate?
        
        // iterate over the updates array, from newest to oldest
        for regionUpdate in regionUpdates.reversed() {
            // try to unwrap the enter update (only works if the last update was an enter)
            // and if this is an exit update
            // and if this update is on the same day as the passed in date
            if let unwrappedEnter = enter,
                regionUpdate.updateType == .exit,
                Calendar.current.isDate(date, inSameDayAs: regionUpdate.date) {
                
                // get the time elapsed between the enter and exit
                duration += unwrappedEnter.date.timeIntervalSince(regionUpdate.date)
                
                // this enter event is now taken into account
                enter = nil
                
            } else if regionUpdate.updateType == .enter {
                // keep this update as the next enter event
                enter = regionUpdate
            }
        }
        
        return duration
    }
    
    // create day entries for the last seven days
    static func dayEntries(from regionUpdates: [RegionUpdate]) -> [DayEntry] {
        var dayEntries: [DayEntry] = []
        let now = Date()
        
        for i in 0..<7 {
            // backwards through the last week
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: now) {
                // get duration in the region for that day
                let duration = durationFor(date: date, from: regionUpdates)
                // get the weekday name
                let weekday = dateFormatter.string(from: date)
                
                // add to the day entries array
                dayEntries.append(DayEntry(duration: duration, weekday: weekday))
            }
        }
        
        return dayEntries.reversed()
    }
}
