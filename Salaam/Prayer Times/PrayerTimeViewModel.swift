//
//  PrayerTimeViewModel.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import SwiftUI
import Combine
import Adhan
import CoreLocation

class PrayerTimeViewModel: ObservableObject {

    @Published var sunrise : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "SUNRISE") ?? ""
    @Published var fajr : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "FAJR") ?? ""
    @Published var notifajr : Date
    @Published var zuhr : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "ZUHR") ?? ""
    @Published var notidhuhr : Date
    @Published var asr : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "ASR") ?? ""
    @Published var notiasr : Date
    @Published var maghrib : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "MAGHRIB") ?? ""
    @Published var notimaghrib : Date
    @Published var isha : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "ISHA") ?? ""
    @Published var notiisha : Date
    @Published var current : String
    @Published var next : String = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.string(forKey: "NEXT") ?? ""
    @Published var lm = LocationManager()
  
    @Published var method: CalculationMethod = .northAmerica {
        didSet {
            UserDefaults(suiteName: "group.babyyoda777.Salaam")?.setValue(method.rawValue, forKey: "method")
            getPrayerTime(locationManager, didUpdateHeading: CLHeading.init())
            objectWillChange.send()
        }
    }
   
    @Published var mashab: Madhab = .hanafi {
        didSet {
            UserDefaults(suiteName: "group.babyyoda777.Salaam")!.setValue(mashab.rawValue, forKey: "mashab")
            getPrayerTime(locationManager, didUpdateHeading: CLHeading.init())
            objectWillChange.send()
        }
    }
    @Published var cal: CalculationParameters?
    @Published var times: PrayerTimes?
    @Published var currentPrayer: Prayer = .isha

    
    init(sunrise: String, fajr : String, notifajr : Date, zuhr : String, notidhuhr : Date, asr : String, notiasr : Date, maghrib : String, notimaghrib : Date, isha : String, notiisha : Date, current : String, next : String) {
        
        

        self.sunrise = sunrise
        self.fajr = fajr
        self.notifajr = notifajr
        self.zuhr = zuhr
        self.notidhuhr = notidhuhr
        self.asr = asr
        self.notiasr = notiasr
        self.maghrib = maghrib
        self.notimaghrib = notimaghrib
        self.isha = isha
        self.notiisha = notiisha
        self.current = current
        self.next = next
        
               if let rawValue = UserDefaults(suiteName: "group.babyyoda777.Salaam")?.string(forKey: "method") {
                self.method = CalculationMethod(rawValue: rawValue) ?? .northAmerica
               }
        
        if let mashab = UserDefaults(suiteName: "group.babyyoda777.Salaam")!.value(forKey: "mashab") {
            self.mashab = Madhab(rawValue: mashab  as! Int) ?? .hanafi
        }
        self.locationManager = CLLocationManager()
        
        self.setup()
                                      
        getPrayerTime(locationManager, didUpdateHeading: CLHeading.init())
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(fajr, forKey: "FAJR")
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(zuhr, forKey: "ZUHR")
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(asr, forKey: "ASR")
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(maghrib, forKey: "MAGHRIB")
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(isha, forKey: "ISHA")
        UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(next, forKey: "NEXT")
    }
      
    private let locationManager: CLLocationManager
    
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
    }
    

    
     func getPrayerTime(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let date = cal.dateComponents([.year, .month, .day], from: Date())
        let coordinates = Coordinates(latitude: (manager.location?.coordinate.latitude) ?? 51.57142, longitude: (manager.location?.coordinate.longitude) ?? 0.3396)
        var par = method.params
        par.madhab = mashab
        par.adjustments.sunrise = -1
        par.adjustments.dhuhr = 4
        par.adjustments.asr = 1
        par.adjustments.isha = -18
        self.times = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: par)
        if let prayers = PrayerTimes(coordinates: coordinates, date: date, calculationParameters: par) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone(identifier: "Europe/London")!
            
            self.sunrise = formatter.string(from: prayers.sunrise)
            self.fajr = formatter.string(from: prayers.fajr)
            self.zuhr = formatter.string(from: prayers.dhuhr)
            self.asr = formatter.string(from: prayers.asr)
            self.maghrib = formatter.string(from: prayers.maghrib)
            self.isha = formatter.string(from: prayers.isha)
            self.notifajr = prayers.fajr
            self.notidhuhr = prayers.dhuhr
            self.notiasr = prayers.asr
            self.notimaghrib = prayers.maghrib
            self.notiisha = prayers.isha
            if let currentPrayer = prayers.currentPrayer() {
                self.current = formatter.string(from: prayers.time(for: currentPrayer))
            } else {
                // if there's no current prayer then it means its between midnight and fajr.
                // It's up to you to decide how you want to handle this situation
                self.current = formatter.string(from: prayers.fajr)
            }
            if let nextPrayer = prayers.nextPrayer() {
                self.next = formatter.string(from: prayers.time(for: nextPrayer))
            } else {
                // if there's no current prayer then it means its between midnight and fajr.
                // It's up to you to decide how you want to handle this situation
                self.next = formatter.string(from: prayers.fajr)
            }
            
        }
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(fajr, forKey: "FAJR")
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(zuhr, forKey: "ZUHR")
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(asr, forKey: "ASR")
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(maghrib, forKey: "MAGHRIB")
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(isha, forKey: "ISHA")
         UserDefaults(suiteName: "group.babyyoda777.Salaam")!.set(next, forKey: "NEXT")
    }
    
            
    
    
    
    
    
  
}
