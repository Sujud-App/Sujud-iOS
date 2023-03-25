//
//  ContentView.swift
//  Sujud
//
//  Created by Muhammad Shah on 20/01/2023.
//

import SwiftUI
import CoreLocation


struct ContentView: View {
    @ObservedObject var model: PrayerTimeViewModel
    @StateObject var noty = NotificationViewModel()
    let currentDateTime = Date()
    init(model: PrayerTimeViewModel) {
        self.model = model
        model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
        
    }
    @State var mode = Mode.ahead
    var body: some View {
        TabView{
            let currentDateTime = Date()
            PrayerView(pray: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0",suhoor: "0", notisuhoor: currentDateTime, fajr: "0",  notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), dates: "" ,  month:"",  currentYear:"")
                .tabItem {
                    Label("Prayer Time", systemImage: "clock.fill")
                }
                .onAppear{
                    model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                    noty.removeNotifications()
                    noty.scheduleNotification(times: (model.times?.fajr)!)
                    noty.scheduleNotification(times: (model.times?.dhuhr)!)
                    noty.scheduleNotification(times: (model.times?.asr)!)
                    noty.scheduleNotification(times: (model.times?.maghrib)!)
                    noty.scheduleNotification(times: (model.times?.isha)!)
                    noty.scheduleNotification(times: (model.notisuhoor))
                    print(model.notisuhoor)
                }
            QuranUI()
                .tabItem {
                    Label("Quran", systemImage: "book.fill")
                }
            QiblaView()
            
                .tabItem {
                    Label("Qibla", systemImage: "location.circle.fill")
                }
            FastingView(pray: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                .tabItem {
                    Label("Prayer Time", systemImage: "clock.fill")
                }
            
            SettingsView(noty: NotificationViewModel(), model: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
             
        }
    }
}


