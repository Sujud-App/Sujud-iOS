//
//  CalculationController.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import Foundation
import SwiftUI
import Adhan
import WidgetKit

struct CalculationSettings: View{
    @ObservedObject var pray: PrayerTimeViewModel
    @StateObject var noti = NotificationViewModel()
    @ObservedObject var model: PrayerTimeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        GeometryReader{ geometry in
            NavigationView{
                List{
                    ForEach(CalculationMethod.allCases, id: \.self) { item in
                        Button(action: {
                            self.model.objectWillChange.send()
                            self.presentationMode.wrappedValue.dismiss()
                            self.pray.method = item
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
                        }
                        )
                        {
                            HStack {
                                Text("\(item.rawValue)")
                                    .foregroundColor(.primary)
                                if pray.method == item {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                                    }
                .navigationTitle("Calculation method")
            }.background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
        }
    }
}
