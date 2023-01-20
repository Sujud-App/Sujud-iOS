//
//  PrayerTimeViewModel.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import SwiftUI
import CoreLocation
import Adhan


struct PrayerView: View{
    @ObservedObject var pray: PrayerTimeViewModel
    @ObservedObject var model: PrayerTimeViewModel
    @Environment(\.presentationMode) var presetationMode
    @State var isPrayer = true
    
    @State var dates : String
    @State var month : String
    @State var currentYear : String
    @State var scale = 1.0
    
    func getIslamicDate(){
        
        let dateFor = DateFormatter()
        
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFor.locale = Locale.init(identifier: "en")
        dateFor.calendar = hijriCalendar
        
        dateFor.dateFormat = "d"
        
        //dateFor.dateFormat = "LLLL"
        let islamic_date = dateFor.string(from: Date())
        
        self.dates = islamic_date
    }
    func getMonth(){
        
        let dateFor = DateFormatter()
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFor.locale = Locale.init(identifier: "en")
        dateFor.calendar = hijriCalendar
        
        dateFor.dateFormat = "dd/mm/yyyy"
        dateFor.dateFormat = "LLLL"
        let nameOfMonth = dateFor.string(from: Date())
        
        self.month = nameOfMonth
        
    }
    func getYear(){
        
        let dateFor = DateFormatter()
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFor.locale = Locale.init(identifier: "en")
        dateFor.calendar = hijriCalendar
        
        dateFor.dateFormat = "yyyy"
        let yearnumber = dateFor.string(from: Date())
        
        self.currentYear = yearnumber
        
    }
    
    
    @State private var bouncing = false
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    CloudShape()
                        .fill(.thinMaterial)
                        .frame(width: 160, height: 100)
                        .padding(.top, 40)
                        .padding(.leading, 40)
                }
                .frame(maxHeight: 160, alignment: bouncing ? .bottom : .topTrailing)
                .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: bouncing)
                VStack{
                    CloudShape()
                        .fill(.thinMaterial)
                        .frame(width: 160, height: 100)
                        .padding(.top, 45)
                        .padding(.leading, -30)
                }
                .frame(maxHeight: 160, alignment: bouncing ? .bottom : .topTrailing)
                .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: bouncing)
            }
            
            .onAppear {
                self.bouncing.toggle()
            }
            ZStack{
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 260, height: 130)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)
                        
                        withAnimation(repeated) {
                            scale = 1.2
                        }
                    }
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 200, height: 100)
                    .scaleEffect(scale)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 1.2)
                        let repeated = baseAnimation.repeatForever(autoreverses: true)
                        
                        withAnimation(repeated) {
                            scale = 1.2
                        }
                    }
                Circle()
                    .fill(Color.init("sun"))
                    .frame(width: 140, height: 70)
                Circle()
                    .fill(Color.init("moon"))
                    .frame(width: 15, height: 7.5)
                    .offset(x: -21, y: -6)
                Circle()
                    .fill(Color.init("moon"))
                    .frame(width: 15, height: 7.5)
                    .offset(x: -25, y: 6)
                Circle()
                    .fill(Color.init("moon"))
                    .frame(width: 20, height: 10)
                    .offset(x: -22, y: -2)
                Circle()
                    .fill(Color.init("moon"))
                    .frame(width: 30, height: 15)
                    .offset(x: -12, y: -18)
                Circle()
                    .fill(Color.init("moon"))
                    .frame(width: 10, height: 5)
                    .offset(x: -10, y: -6)
            }
            .padding(.top, 10)
            .padding(.trailing, -40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            VStack{
                VStack{
                    VStack{
                        Text("\(dates) \(month) \(currentYear)")
                            .fontWeight(.bold)
                            .frame(alignment: .leading)
                            .font(.system(size:15))
                            .onAppear {
                                self.getIslamicDate()
                                self.getMonth()
                                self.getYear()
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    VStack{
                        Text("السلام عليكم")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .bottomLeading)
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(15)
                ZStack{
                    VStack{
                        HStack{
                            Text("Fajr")
                            Spacer()
                            Text(pray.fajr)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .onAppear {
                            model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                        }
                        HStack{
                            Text("Sunrise")
                            Spacer()
                            Text(pray.sunrise)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        HStack{
                            Text("Zuhr")
                            Spacer()
                            Text(pray.zuhr)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        HStack{
                            Text("Asr")
                            Spacer()
                            Text(pray.asr)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        HStack{
                            Text("Maghrib")
                            Spacer()
                            Text(pray.maghrib)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        HStack{
                            Text("Isha")
                            Spacer()
                            Text(pray.isha)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
                .padding(10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
    }
    
}

struct CloudShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.81028 * rect.width, y: rect.minY + 0.39009 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.77271 * rect.width, y: rect.minY + 0.39612 * rect.height), control1: CGPoint(x: rect.minX + 0.79766 * rect.width, y: rect.minY + 0.39009 * rect.height), control2: CGPoint(x: rect.minX + 0.78507 * rect.width, y: rect.minY + 0.39210 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.69093 * rect.width, y: rect.minY + 0.22300 * rect.height), control1: CGPoint(x: rect.minX + 0.76339 * rect.width, y: rect.minY + 0.32133 * rect.height), control2: CGPoint(x: rect.minX + 0.73325 * rect.width, y: rect.minY + 0.25753 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.55572 * rect.width, y: rect.minY + 0.21906 * rect.height), control1: CGPoint(x: rect.minX + 0.64862 * rect.width, y: rect.minY + 0.18847 * rect.height), control2: CGPoint(x: rect.minX + 0.59879 * rect.width, y: rect.minY + 0.18702 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.29076 * rect.width, y: rect.minY + 0.02004 * rect.height), control1: CGPoint(x: rect.minX + 0.51674 * rect.width, y: rect.minY + 0.04650 * rect.height), control2: CGPoint(x: rect.minX + 0.39812 * rect.width, y: rect.minY + -0.04260 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.16694 * rect.width, y: rect.minY + 0.44594 * rect.height), control1: CGPoint(x: rect.minX + 0.18340 * rect.width, y: rect.minY + 0.08269 * rect.height), control2: CGPoint(x: rect.minX + 0.12797 * rect.width, y: rect.minY + 0.27339 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.00002 * rect.width, y: rect.minY + 0.72706 * rect.height), control1: CGPoint(x: rect.minX + 0.07290 * rect.width, y: rect.minY + 0.45072 * rect.height), control2: CGPoint(x: rect.minX + -0.00139 * rect.width, y: rect.minY + 0.57584 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.17212 * rect.width, y: rect.minY + 1.00000 * rect.height), control1: CGPoint(x: rect.minX + 0.00143 * rect.width, y: rect.minY + 0.87829 * rect.height), control2: CGPoint(x: rect.minX + 0.07803 * rect.width, y: rect.minY + 0.99976 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.81028 * rect.width, y: rect.minY + 1.00000 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.69504 * rect.height), control1: CGPoint(x: rect.minX + 0.91505 * rect.width, y: rect.minY + 1.00000 * rect.height), control2: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.86347 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.81028 * rect.width, y: rect.minY + 0.39009 * rect.height), control1: CGPoint(x: rect.minX + 1.00000 * rect.width, y: rect.minY + 0.52662 * rect.height), control2: CGPoint(x: rect.minX + 0.91505 * rect.width, y: rect.minY + 0.39009 * rect.height))
        path.closeSubpath()
        return path
        
    }
    
}
