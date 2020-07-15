//
//  DayEntryView.swift
//  IntoTheWild
//
//  Created by Monty Boyer on 7/12/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import SwiftUI

struct DayEntryView: View {
    
    let duration: TimeInterval
    let max: TimeInterval
    let weekday: String
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    // move the rect to the bottom of the display
                    Spacer(minLength: 0)

                    ZStack(alignment: .top) {
                        // set the rect frame height based on the duration & max
                        Rectangle().frame(height: geometry.size.height *
                            CGFloat(self.duration / self.max))

                        // if there is a duration display it
                        if self.duration > 0 {
                            Text(self.durationString(from: self.duration))
                                .foregroundColor(Color("durationTextColor"))
                                .font(.footnote)
                        }
                    }
                }
            }
            
            // the first letter of the weekday
            Text(String(self.weekday.first ?? " "))
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text(voiceOverGroupString(for: duration)))
    }

    // from the duration provide a string as “1h 11m”
    func durationString(from duration: TimeInterval, forVoiceOver: Bool = false) -> String {
        if duration < 1 {
            return "no time outside"        // better for VoiceOver users
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        
        if forVoiceOver {
            formatter.unitsStyle = .full    // better for VoiceOver users
        } else {
            formatter.unitsStyle = .abbreviated
        }
        
        return formatter.string(from: duration) ?? ""
    }
    
    // create a VoiceOver friendly duration string
    func voiceOverGroupString(for duration: TimeInterval) -> String {
        let duration = durationString(from: duration, forVoiceOver: true)
        print("duration is \(duration)")
        return "\(duration) on \(weekday)"
    }
}

struct DayEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DayEntryView(duration: 120, max: 240, weekday: "Friday")
            DayEntryView(duration: 20640, max: 30000, weekday: "Tuesday")
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .dark)
        }
    }
}
