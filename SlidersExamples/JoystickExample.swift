//
//  JoystickExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders
import CGExtender


struct JoystickExample: View {
    @State var state: JoyState = .inactive
    @State var rectOffset: CGSize = .zero
    @State var canLock: Bool = true
    @State var angle: Angle = .zero
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var overlay: some View {
        
        return VStack(alignment: .leading, spacing: 5){
            Text("Drag Anywhere To Begin").font(.title)
            Text("The yellow/black circle is the") + Text(" lockbox.").italic() +
            Text(" Try releasing the gesture inside the yellow circle")
            
            Group {
                HStack {
                    Spacer()
                    Text("x").bold().frame(width: 100)
                    Text("y").bold().frame(width: 100)
                }
                Divider()
                HStack {
                    Text("Translation:").bold().fixedSize()
                    Spacer()
                    Text("\(String(format: "%.0f", state.translation.width))").frame(width: 100)
                    Text("\(String(format: "%.0f", state.translation.height))").frame(width: 100)
                }
                Divider()
                HStack {
                    Text("Velocity:").bold().fixedSize()
                    Spacer()
                    Text("\(String(format: "%.0f", state.velocity.width))").frame(width: 100)
                    Text("\(String(format: "%.0f", state.velocity.height))").frame(width: 100)
                }
                Divider()
                HStack {
                    Text("Acceleration:").bold().fixedSize()
                    Spacer()
                    Text("\(String(format: "%.0f", state.acceleration.width))").frame(width: 100)
                    Text("\(String(format: "%.0f", state.acceleration.height))").frame(width: 100)
                }
                Divider()
            }
         
            HStack {
                Toggle(isOn: $canLock, label: {Text("Can Lock")}).frame(maxWidth: 150)
                Spacer()
                Text(self.state.isLocked ? "Locked" : "Not Locked")
                Spacer()
            }
            
        }.offset(x: 0, y: -200)
            .padding(.horizontal, 30)
    }
    var body: some View {
        Joystick(state: $state, radius: 50, canLock: canLock, isDisabled: false)
            .background(Rectangle()
                .fill(Color.red)
                .frame(width: 50, height: 50)
                .rotationEffect(angle)
                .offset(rectOffset)
                .onReceive(timer, perform: { (time) in
                    if self.state.translation != .zero {
                        let scale = 5*sqrt(self.state.translation.magnitudeSquared)/50.0
                        let x = scale*cos(self.state.angle.radians)
                        let y = scale*sin(self.state.angle.radians)
                        self.rectOffset += CGSize(width: x, height: y)
                    }
                    
                    if self.state.isLocked {
                        self.angle += Angle(degrees: 1)
                    }
                })
                .animation(.linear))
            .overlay(overlay)
        .navigationBarTitle("Joystick")
    }
}

struct JoystickExample_Previews: PreviewProvider {
    static var previews: some View {
        JoystickExample()
    }
}
