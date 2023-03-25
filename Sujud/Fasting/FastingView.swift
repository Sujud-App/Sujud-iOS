//
//  FastingView.swift
//  Sujud
//
//  Created by Muhammad Shah on 18/03/2023.
//

import SwiftUI
import CoreLocation
import WidgetKit
import UserNotifications

struct FastingView: View {
    @State private var date = Date()
    @ObservedObject var pray: PrayerTimeViewModel
    @ObservedObject var model: PrayerTimeViewModel
    
    @Environment(\.presentationMode) var presetationMode
    @State var isPrayer = true
    
    var body: some View {
        NavigationView{
            VStack{
                
                TimerExample(endDate: model.notimaghrib,pray: PrayerTimeViewModel(sunrise: "0", suhoor: "0", notisuhoor: currentDateTime, fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0",suhoor: "0", notisuhoor: currentDateTime, fajr: "0",  notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), percentage: 1)
                HStack{
                    HStack{
                        VStack{
                            Text("Suhoor")
                            Text(pray.suhoor)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onAppear {
                        model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    HStack{
                        VStack{
                            Text("Iftar")
                            Text(pray.maghrib)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
            }.navigationTitle("Fasting Timer")
            
        }
        
    }
        
}





struct TimerExample: View {
    
    let endDate: Date
    @State private var date = Date()
    @ObservedObject var pray: PrayerTimeViewModel
    @ObservedObject var model: PrayerTimeViewModel
    @Environment(\.presentationMode) var presetationMode
    @State var isPrayer = true
    
    
    @State var percentage : Double
    
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            VStack {
                
                let value = secondsValue(for: endDate)
                if percentage > 60{
                    ZStack{
                        
                        Circle()
                            .stroke(lineWidth: 25)
                            .foregroundColor(.gray)
                            .opacity(0.25)
                            .overlay{
                                //percentage time left
                                //                            Text("\(String(Int(100 - (((pray.notimaghrib.timeIntervalSince(.now))/(pray.notimaghrib.timeIntervalSince(pray.notisuhoor))) * 100))))% complete")
                                //                                .font(.system(size: 30))
                                
                                
                                
                                VStack{
                                    Text("Time to eat!")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                    }
                    .padding(20)
                }
                else if percentage == 60{
                    ZStack{
                        
                        Circle()
                            .stroke(lineWidth: 25)
                            .foregroundColor(.gray)
                            .opacity(0.25)
                            .overlay{
                                //percentage time left
                                //                            Text("\(String(Int(100 - (((pray.notimaghrib.timeIntervalSince(.now))/(pray.notimaghrib.timeIntervalSince(pray.notisuhoor))) * 100))))% complete")
                                //                                .font(.system(size: 30))
                                
                                
                                
                                VStack{
                                    Text("Time to eat!")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                    }
                    .padding(20)

                }
                else{
                    ZStack{
                        
                        Circle()
                            .stroke(lineWidth: 25)
                            .foregroundColor(.gray)
                            .opacity(0.25)
                            .overlay{
                                //percentage time left
                                //                            Text("\(String(Int(100 - (((pray.notimaghrib.timeIntervalSince(.now))/(pray.notimaghrib.timeIntervalSince(pray.notisuhoor))) * 100))))% complete")
                                //                                .font(.system(size: 30))
                                
                                
                                
                                VStack{
                                    Text(endDate, style: .timer)
                                        .font(.system(size: 30))
                                    Text("remaining until Iftar")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                        Circle()
                            .trim(from: 0, to: value)
                            .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .rotationEffect((Angle(degrees: 270)))
                    }
                    .padding(20)
                    
                }
                
            }
            .onAppear{
                secondsValue(for: endDate)
            }
        }
    }
    public func secondsValue(for date: Date) -> Double  {
        
        // percentage of 60 seconds out of total time left until inftar, very complicated and annoyed me a lot lol.
        percentage = ((100 - (((pray.notimaghrib.timeIntervalSince(.now))/(pray.notimaghrib.timeIntervalSince(pray.notisuhoor))) * 100)) * 60)/100
        print(percentage)
        
        
        if percentage == 60{
            let content = UNMutableNotificationContent()
            content.title = "Time to break fast."
            content.subtitle = "It is iftar time."
            content.sound = UNNotificationSound.default

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)

        }
        
        return Double(percentage) / 60
        
    }
}

