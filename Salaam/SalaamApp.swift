//
//  SalaamApp.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import SwiftUI

@main
struct SalaamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
        }
    }
}
