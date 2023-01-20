//
//  Widget.swift
//  Widget
//
//  Created by Muhammad Shah on 20/01/2023.
//
import WidgetKit
import SwiftUI
import Intents
import Adhan



struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        

        
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct PrayerWidgetEntryView : View {
    var entry: Provider.Entry
    @ObservedObject var pray: PrayerTimeViewModel
    @ObservedObject var model: PrayerTimeViewModel
    @State var dates : String
    @State var month : String
    @State var currentYear : String
    @State var sunrise : String
    @State var fajr : String
    @State var notifajr : Date
    @State var zuhr : String
    @State var notidhuhr : Date
    @State var asr : String
    @State var notiasr : Date
    @State var maghrib : String
    @State var notimaghrib : Date
    @State var isha : String
    @State var notiisha : Date
    @State var current : String
    @State var next : String
    @State var method: CalculationMethod = .northAmerica {
        didSet {
            UserDefaults(suiteName: "group.babyyoda777.Salaam-iOS")!.setValue(method.rawValue, forKey: "method")
            getPrayerTime()
        }
    }
   
    @State var mashab: Madhab = .hanafi {
        didSet {
            UserDefaults(suiteName: "group.babyyoda777.Salaam-iOS")!.setValue(mashab.rawValue, forKey: "mashab")
            getPrayerTime()
        }
    }
    
    @State var times: PrayerTimes?
    func start() {
        
        
       
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
        
               if let rawValue = UserDefaults(suiteName: "group.babyyoda777.Salaam-iOS")!.string(forKey: "method") {
                self.method = CalculationMethod(rawValue: rawValue) ?? .northAmerica
               }
        
        if let mashab = UserDefaults(suiteName: "group.babyyoda777.Salaam-iOS")!.value(forKey: "mashab") {
            self.mashab = Madhab(rawValue: mashab as! Int) ?? .hanafi
        }
                                      
        getPrayerTime()

        
        
    }
    
    func getPrayerTime() {
       let cal = Calendar(identifier: Calendar.Identifier.gregorian)
       let date = cal.dateComponents([.year, .month, .day], from: Date())
       let coordinates = Coordinates(latitude: 51.589085789871454, longitude: -0.332268229333173)
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

   }

    
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

    @Environment(\.widgetFamily) var family

    @State var scale = 1.0
    var body: some View {

        switch family{
        case .systemMedium:
            ZStack{
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
                .scaleEffect(0.5)
                .offset(x: 15)
                .padding(.top, -130)
                VStack{
                    VStack{
                        HStack{
                            Text("Next prayer:")
                                .fontWeight(.bold)
                                .font(.system(size:20))
                            Text(model.next)
                                .fontWeight(.bold)
                                .font(.system(size:20))
                            
                        }
                        .padding(.bottom, 8)
                    }
                    HStack{
                        VStack{
                            Text("Fajr")
                                .fontWeight(.bold)
                                .font(.system(size:18))
                                .padding(.bottom, 5)
                            Image(systemName: "sun.haze.fill")
                                .symbolRenderingMode(.multicolor)
                                .padding(.bottom, 5)
                            Text(model.fajr)
                                .fontWeight(.bold)
                                .font(.system(size:15))
                            
                        }
                        .padding(.trailing, 2)
                        .padding(.leading, 2)
                        VStack{
                            Text("Zuhr")
                                .fontWeight(.bold)
                                .font(.system(size:18))
                                .padding(.bottom, 5)
                            Image(systemName: "sun.max.fill")
                                .symbolRenderingMode(.multicolor)
                                .padding(.bottom, 5)
                            Text(model.zuhr)
                                .fontWeight(.bold)
                                .font(.system(size:15))
                            
                        }
                        .padding(.trailing, 2)
                        .padding(.leading, 2)
                        VStack{
                            Text("Asr")
                                .fontWeight(.bold)
                                .font(.system(size:18))
                                .padding(.bottom, 5)
                            Image(systemName: "sun.min.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.yellow)
                                .padding(.bottom, 5)
                            Text(model.asr)
                                .fontWeight(.bold)
                                .font(.system(size:15))
                            
                        }
                        .padding(.trailing, 2)
                        .padding(.leading, 2)
                        VStack{
                            Text("Maghrib")
                                .fontWeight(.bold)
                                .font(.system(size:18))
                                .padding(.bottom, 5)
                            Image(systemName: "sunset.fill")
                                .symbolRenderingMode(.multicolor)
                                .padding(.bottom, 5)
                            Text(model.maghrib)
                                .fontWeight(.bold)
                                .font(.system(size:15))
                            
                        }
                        .padding(.trailing, 2)
                        .padding(.leading, 2)
                        VStack{
                            Text("Isha")
                                .fontWeight(.bold)
                                .font(.system(size:18))
                                .padding(.bottom, 5)
                            Image(systemName: "moon.stars.fill")
                                .symbolRenderingMode(.multicolor)
                                .padding(.bottom, 5)
                            Text(model.isha)
                                .fontWeight(.bold)
                                .font(.system(size:15))
                            
                        }
                        .padding(.trailing, 2)
                        .padding(.leading, 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
                .onAppear(perform: {
                    model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                })
            }
        case .systemSmall:
            GeometryReader{ geometry in
                ZStack{
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
                    .scaleEffect(0.6)
                    .offset(x: 25)
                    .padding(.top, -140)
                    VStack{
                        HStack{
                            Text("Fajr")
                            Spacer()
                            Text(pray.fajr)
                        }
                        .fontWeight(.bold)
                        .font(.system(size:15))
                        .padding(.bottom, 0.1)
                        HStack{
                            Text("Zuhr")
                            Spacer()
                            Text(pray.zuhr)
                        }
                        .fontWeight(.bold)
                        .font(.system(size:15))
                        .padding(.bottom, 0.1)
                        HStack{
                            Text("Asr")
                            Spacer()
                            Text(pray.asr)
                        }
                        .fontWeight(.bold)
                        .font(.system(size:15))
                        .padding(.bottom, 0.1)
                        HStack{
                            Text("Maghrib")
                            Spacer()
                            Text(pray.maghrib)
                        }
                        .fontWeight(.bold)
                        .font(.system(size:15))
                        .padding(.bottom, 0.1)
                        HStack{
                            Text("Isha")
                            Spacer()
                            Text(pray.isha)
                        }
                        .fontWeight(.bold)
                        .font(.system(size:15))
                        .padding(.bottom, 0.4)
                        .onAppear{
                            model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                        }
                    }
                    .padding(.top, 15)
                    .padding(.trailing, 5)
                    .padding(10)
                    .frame(width: 160, alignment: .trailing)
                    .offset(x: -50)
            }
        }
            .frame(width: .infinity, height: .infinity, alignment: .trailing)
            .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
        
        case .systemLarge:
            VStack{

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
                .scaleEffect(0.8)
                .offset(x: 90, y: 25)
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
                .offset(x: 20, y: -5)
                VStack{
                    HStack{
                        Text("Next prayer:")
                            .fontWeight(.bold)
                            .font(.system(size:20))
                        Text(model.next)
                            .fontWeight(.bold)
                            .font(.system(size:20))
                        
                    }
                    .padding(.bottom, 8)
                }
                HStack{
                    VStack{
                        Text("Fajr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.haze.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.fajr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Zuhr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.max.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.zuhr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Asr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.min.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 5)
                        Text(model.asr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Maghrib")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sunset.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.maghrib)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Isha")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "moon.stars.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.isha)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                }
            }
            .offset(y:-20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
            .onAppear(perform: {
                model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
            })
        @unknown default:
            VStack{
                VStack{
                    HStack{
                        Text("Next prayer:")
                            .fontWeight(.bold)
                            .font(.system(size:20))
                        Text(model.next)
                            .fontWeight(.bold)
                            .font(.system(size:20))
                        
                    }
                    .padding(.bottom, 8)
                }
                HStack{
                    VStack{
                        Text("Fajr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.haze.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.fajr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Zuhr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.max.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.zuhr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Asr")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sun.min.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.yellow)
                            .padding(.bottom, 5)
                        Text(model.asr)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Maghrib")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "sunset.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.maghrib)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                    VStack{
                        Text("Isha")
                            .fontWeight(.bold)
                            .font(.system(size:18))
                            .padding(.bottom, 5)
                        Image(systemName: "moon.stars.fill")
                            .symbolRenderingMode(.multicolor)
                            .padding(.bottom, 5)
                        Text(model.isha)
                            .fontWeight(.bold)
                            .font(.system(size:15))
                        
                    }
                    .padding(.trailing, 2)
                    .padding(.leading, 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.init("GD2").opacity(0.6), .init("GD1")]), startPoint: .bottom, endPoint: .top))
            .onAppear(perform: {
                model.getPrayerTime(CLLocationManager(), didUpdateHeading: CLHeading.init())
                start()
                WidgetCenter.shared.reloadAllTimelines()
            })
        }
}
}


@main
struct PrayerWidget: Widget {
    let kind: String = "PrayerWidget"
    let currentDateTime = Date()
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PrayerWidgetEntryView(entry: entry, pray: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), model: PrayerTimeViewModel(sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0"), dates: "", month: "", currentYear: "", sunrise: "0", fajr: "0", notifajr: currentDateTime, zuhr: "0", notidhuhr: currentDateTime, asr: "0", notiasr: currentDateTime, maghrib: "0", notimaghrib: currentDateTime, isha: "0", notiisha: currentDateTime, current: "0", next: "0")
        }
        .configurationDisplayName("Prayer Times")
        .description("View daily and next prayer times right from your homescreen.")
    }
}

