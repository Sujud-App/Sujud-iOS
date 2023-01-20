//
//  LocationManager.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import Foundation
import CoreLocation
import Combine



extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.geocode()
    }
    
 
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    
}

class LocationManager: NSObject, ObservableObject {
  private let geocoder = CLGeocoder()
  private let locationManager = CLLocationManager()
  let objectWillChange = PassthroughSubject<Void, Never>()

  @Published var status: CLAuthorizationStatus? {
    willSet { objectWillChange.send() }
  }
    
    @Published var someVar: Int = 0 {
        willSet { objectWillChange.send() }
      }

  @Published var location: CLLocation? {
    willSet { objectWillChange.send() }
  }

  override init() {
    super.init()
    
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
  }

    @Published var placemark: CLPlacemark? {
       willSet { objectWillChange.send() }
     }

     private func geocode() {
       guard let location = self.location else { return }
       geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
         if error == nil {
           self.placemark = places?[0]
         } else {
           self.placemark = nil
         }
       })
     }
}

