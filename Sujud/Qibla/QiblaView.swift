//
//  QiblaView.swift
//  Salaam
//
//  Created by Muhammad Shah on 20/01/2023.
//

import SwiftUI
import Foundation
import Combine
import CoreLocation
import Adhan
import CoreHaptics


    class CompassHeading: NSObject, ObservableObject, CLLocationManagerDelegate {
        var objectWillChange = PassthroughSubject<Void, Never>()
        var degrees: Double = .zero {
            didSet {
                objectWillChange.send()
            }
        }
        var og: Double = .zero {
            didSet {
                objectWillChange.send()
            }
        }
        var qibla: Double = .zero {
            didSet {
                objectWillChange.send()
            }
        }
        
        private let locationManager: CLLocationManager
        
        override init() {
            self.locationManager = CLLocationManager()
            super.init()
            
            self.locationManager.delegate = self
            self.setup()
        }
        
        private func setup() {
            self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.headingAvailable() {
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            self.qibla = Qibla(coordinates: Coordinates(latitude: (manager.location?.coordinate.latitude) ?? 51.57142, longitude: (manager.location?.coordinate.longitude) ?? 0.3396)).direction
            self.degrees = (-1 * newHeading.magneticHeading) + qibla
            self.og = (-1 * newHeading.magneticHeading)
        }
    }

enum Mode {
    case ahead, right, left
}


struct QiblaView: View {
    @State var mode = Mode.ahead
    @State var back:Color = Color.black
    @ObservedObject var compassHeading = CompassHeading()
    var location: CLLocation?
    let locationManager = CLLocationManager()


    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    Circle()
                        .fill(Color(mode == .ahead ? UIColor.label : UIColor.secondaryLabel))
                        .frame(width: 16, height: 16)
                        .offset(y: mode == .ahead ? -4 : -8)
                        .scaleEffect(mode == .ahead ? 2 : 1)
                    
                    Spacer()
                }
                
                    
            }
            .frame(width: 312, height: 312)

            Image(systemName: "arrow.up")
        
                .font(.system(size: 192, weight: .bold))
                .rotationEffect(Angle(degrees: self.compassHeading.degrees))

                
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Qibla Direction")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
                
                VStack {
                    
                    HStack {
                        if mode == .right {
                            Text("\(abs(Int(compassHeading.degrees)))")
                            Text("degrees")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        else if mode == .left{
                            Text("\(abs(Int(compassHeading.degrees)))")
                            Text("degrees")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        else {
                            Text("Straight")
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        if mode == .right {
                            Text("to your")
                            Text("left")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        else if mode == .left{
                            Text("to your")
                            Text("right")
                                .foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        else {
                            Text("ahead!")
                        }
                        
                        Spacer()
                    }
                }
                .font(.system(size: 48, design: .rounded))
                .padding(.bottom)
            }
            .padding()
        }
        .background((mode == .ahead ? Color.green : Color(UIColor.systemBackground)).edgesIgnoringSafeArea(.all))
        .onChange(of: compassHeading.degrees, perform: {newValue in
            if Int(compassHeading.degrees) == 0{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .rigid)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == 1{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == 2{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == 3{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == 4{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == 5{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == -1{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == -2{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == -3{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == -4{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .light)
                impactMed.impactOccurred()
            }
            else if Int(compassHeading.degrees) == -5{
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .ahead
                }
                let impactMed = UIImpactFeedbackGenerator(style: .soft)
                impactMed.impactOccurred()
            }
            else if abs(Int(compassHeading.degrees)) == Int(compassHeading.degrees){
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .right
                }
            }
            else if Int(compassHeading.degrees) == -abs(Int(compassHeading.degrees)){
                withAnimation(.easeInOut(duration: 1)) {
                    mode = .left
                }
            }
            locationManager.startUpdatingHeading()
        })
        .onAppear{
            locationManager.startUpdatingLocation()
        }


    
        
    }
        

    
}


