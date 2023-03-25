//
//  SettingsView.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import Foundation
import SwiftUI
import Adhan

struct SettingsView: View{
    @ObservedObject var noty: NotificationViewModel
    @ObservedObject var model: PrayerTimeViewModel
    @StateObject var noti = NotificationViewModel()
    @State private var showingSheet = false
    @State private var showedSheet = false
    var body: some View{
        GeometryReader { _ in
                NavigationView{
                    
                    List{
                        Section{
                            HStack {
                                Text("Notifications")
                                Toggle("", isOn: $noty.sendNotification)
                                    .onChange(of: noty.sendNotification) { (value) in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            if noty.sendNotification == true {
                                                noty.requestPermission()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                                    if noty.sendNotification == true {
                                                        noty.scheduleNotification(times: (model.times?.fajr)!)
                                                        noty.scheduleNotification(times: (model.times?.dhuhr)!)
                                                        noty.scheduleNotification(times: (model.times?.asr)!)
                                                        noty.scheduleNotification(times: (model.times?.maghrib)!)
                                                        noty.scheduleNotification(times: (model.times?.isha)!)
                                                    }
                                                }
                                                
                                            } else {
                                                noty.removeNotifications()
                                            }
                                        }
                                    }
                            }
                        }.navigationTitle("Settings")
                        
                        Section{
                            Button("Calulation Method") {
                                showingSheet.toggle()
                            }
                            .sheet(isPresented: $showingSheet) {
                                CalculationSettings(pray: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                            }
                            Button("Madhab") {
                                showedSheet.toggle()
                            }
                            .sheet(isPresented: $showedSheet) {
                                MadhabSettings(pray: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                            }
                        }.listRowSeparator(.hidden)
                        Section{
                            Link("\(Image(systemName: "link")) Donate to help support me!", destination: URL(string: "https://paypal.me/babyyoda777?country.x=GB&locale.x=en_GB")!)
                                .foregroundColor(.primary)
                            Link("\(Image(systemName: "link")) Find out more about me!", destination: URL(string: "https://babyyoda777.github.io")!)
                                .foregroundColor(.primary)
                        }.listRowSeparator(.hidden)
                        Section(footer:
                                    Text("Designed and developed by Muhammad Shah.")){
                            Link("\(Image(systemName: "link"))   Official Website ", destination: URL(string: "https://salaam.ml")!)
                                .foregroundColor(.primary)
                        }.listRowSeparator(.hidden)
                        Spacer()
                            .listRowBackground(Color.init("back"))
                    }
                    .listStyle(InsetGroupedListStyle()) // this has been renamed in iOS 14.*, as mentioned by @Elijah Yap
                    .environment(\.horizontalSizeClass, .regular)
                    .navigationTitle("Contact Us")
                    
                }.navigationViewStyle(StackNavigationViewStyle())
                    .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
        }
    }
    
}



