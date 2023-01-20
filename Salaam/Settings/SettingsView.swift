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
                                CalculationSettings(pray: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                            }
                            Button("Madhab") {
                                showedSheet.toggle()
                            }
                            .sheet(isPresented: $showedSheet) {
                                MadhabSettings(pray: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"))
                            }
                        }.listRowSeparator(.hidden)
                        Section{
                            Link("\(Image(systemName: "link")) Donate to Harrow Mosque  ", destination: URL(string: "https://paypal.com/donate/?hosted_button_id=FF9AN9AKM8BXS&source=url")!)
                                .foregroundColor(.primary)
                            Link("\(Image(systemName: "link")) Find out more about me!  ", destination: URL(string: "https://babyyoda777.github.io")!)
                                .foregroundColor(.primary)
                        }.listRowSeparator(.hidden)
                        Section(footer:
                                    Text("Designed and developed by Muhammad Shah. Credits: Thank You to Shah Law Chambers for helping fund this project.")){
                            Link("\(Image(systemName: "play.rectangle.fill"))    YouTube ", destination: URL(string: "https://www.youtube.com/user/harrowmosque/videos")!)
                                .foregroundColor(.primary)
                            Link("\(Image(systemName: "camera.metering.center.weighted"))   Instagram ", destination: URL(string: "https://www.instagram.com/harrowmosque/")!)
                                .foregroundColor(.primary)
                            Link("\(Image("logo"))   Harrow Central Mosque Website ", destination: URL(string: "https://www.harrowmosque.org.uk")!)
                                .foregroundColor(.primary)
                                .padding(.bottom, 3)
                                .padding(.top, -3)
                            Link("\(Text("f").fontWeight(.bold).font(.system(size: 30)))      FaceBook ", destination: URL(string: "https://www.facebook.com/HarrowMosque")!)
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



