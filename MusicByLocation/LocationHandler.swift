//
//  LocationHandler.swift
//  MusicByLocation
//
//  Created by Pierre Buclez on 02/03/2023.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var lastKnownLoction: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }

    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
        
    }
    
    func requestLocation() {
        manager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: {(placemarks, error) in
                if error != nil {
                    self.lastKnownLoction = "Could not prefrom lookup of location from coordinate information"
                } else {
                    if let firstPlacemark = placemarks?[0] {
                        self.lastKnownLoction = firstPlacemark.subLocality ?? "Couldn't find locality"
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownLoction = "Error finding location"
    }
    
}
