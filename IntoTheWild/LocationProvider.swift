//
//  LocationProvider.swift
//  IntoTheWild
//
//  Created by Monty Boyer on 7/12/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import UIKit
import CoreLocation
import LogStore

class LocationProvider: NSObject, CLLocationManagerDelegate, ObservableObject {

    let locationManager: CLLocationManager
    var regionUpdates: [RegionUpdate] = [] {     // to store the region updates
        // update dayEntries when regionUpdates changes
        didSet {
            dayEntries = DayEntriesCalculator.dayEntries(from: regionUpdates)
        }
    }
    
    @Published var dayEntries: [DayEntry] = [] {
        // update max duration when dayEntries changes
        didSet {
            max = dayEntries.reduce(1.0, { result, nextDayEntry in
                Swift.max(result, nextDayEntry.duration)        // using the global max function
            })
        }
    }
    
    @Published var wrongAuthorization = false   // track & publish the authorization status

    var max: TimeInterval = 1                   // maximum duration

    private let geofenceRadius: Double = 10     // in meters
    
    override init() {
        // get & save a new instance of location manager
        locationManager = CLLocationManager()
        
        // init super before using self
        super.init()
        
        // try to get region updates saved in the file system
        loadRegionUpdates()
        
        locationManager.delegate = self
        
        // we need Always authorization to request the location even if the app is not active
        locationManager.requestAlwaysAuthorization()
    }
    
    
    // handle change in location authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            printLog("authorization success")
        case .notDetermined:
            printLog("authorization not determined")
        default:
            wrongAuthorization = true       // this is handled by a VStack in ContentView
        }
    }
    
    // get the current location, one time only
    func setHome() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the most recent location
        guard let location = locations.last else { return }
        printLog("location: \(location)")
        
        // set a circular region centered on this location named home
        let region = CLCircularRegion(center: location.coordinate, radius: geofenceRadius, identifier: "home")
        
        // monitor locations in that region
        manager.startMonitoring(for: region)
    }
    
    // save an entry into the geofence region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        printLog("didEnterRegion: \(String(describing: region))")
        
        addRegionUpdate(type: .enter)
    }
    
    // save an exit from the geofence region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        printLog("didExitRegion: \(String(describing: region))")
        
        addRegionUpdate(type: .exit)
    }
    
    func addRegionUpdate(type: UpdateType) {
        // check that this update type is different from the last we recorded
        let lastUpdateType = regionUpdates.last?.updateType
        if type != lastUpdateType {
            // add a new region update to the array
            let regionUpdate = RegionUpdate(date: Date(), updateType: type)
            regionUpdates.append(regionUpdate)
            
            writeRegionUpdates()
        }
    }
    
    // save the updates to the file system
    func writeRegionUpdates() {
        do {
            // try to encode the region updates array
            let data = try JSONEncoder().encode(regionUpdates)
            
            // try to write to the file
            try data.write(to: FileManager.regionUpdatesDataPath(), options: .atomic)
            
        } catch {
            printLog("json file write error: \(error)")
        }
    }
    
    func loadRegionUpdates() {
        do {
            // try to read and decode the region updates array
            let data = try Data(contentsOf: FileManager.regionUpdatesDataPath())
            regionUpdates = try JSONDecoder().decode([RegionUpdate].self, from: data)

        } catch {
            printLog("json file read error: \(error)")

        }
    }

    // this method is required of a delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // just log the error
        printLog("locationManager didFailWithError: \(error)")
    }
    
}
