//
//  MadhabController.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import Foundation
import SwiftUI
import Adhan
import WidgetKit

struct MadhabSettings: View{
    @ObservedObject var pray: PrayerTimeViewModel
    @StateObject var noti = NotificationViewModel()
    @ObservedObject var model: PrayerTimeViewModel
    @Environment(\.presentationMode) var presetationMode
    let gradient = LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top)
    var body: some View{
        GeometryReader{ geometry in
            NavigationView{
                List{
                    ForEach(Madhab.allCases, id: \.self) { item in
                        Button(action: {
                            self.model.objectWillChange.send()
                            self.presetationMode.wrappedValue.dismiss()
                            self.model.mashab = item
                            self.noti.removeNotifications()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                if noti.sendNotification == true {
                                    noti.scheduleNotification(times: (model.times?.fajr)!)
                                    noti.scheduleNotification(times: (model.times?.dhuhr)!)
                                    noti.scheduleNotification(times: (model.times?.asr)!)
                                    noti.scheduleNotification(times: (model.times?.maghrib)!)
                                    noti.scheduleNotification(times: (model.times?.isha)!)
                                }
                            }
                            WidgetCenter.shared.reloadAllTimelines()
                        })  {
                            
                            HStack{
                                Text("\(item.names)")
                                    .foregroundColor(.primary)
                                Spacer()
                                if self.model.mashab == item {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                 }
                .navigationTitle("Madhab")
            }
        }
    }
}
