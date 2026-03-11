// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

struct JoystickExample: View {
    @State var state: JoyState = .inactive
    @State var rectOffset: CGSize = .zero
    @State var canLock: Bool = true
    @State var angle: Angle = .zero
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    @ViewBuilder
    var overlay: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Drag Anywhere To Begin")
                .font(.title)
            
            Text("The yellow/black circle is the \(Text(" lockbox.").italic()) Try releasing the gesture inside the yellow circle")
            
            Group {
                HStack {
                    Spacer()
                    
                    Text("x")
                        .bold()
                        .frame(width: 100)
                    
                    Text("y")
                        .bold()
                        .frame(width: 100)
                }
                
                Divider()
                
                HStack {
                    Text("Translation:")
                        .bold()
                        .fixedSize()
                    
                    Spacer()
                    
                    Text("\(String(format: "%.0f", state.translation.width))")
                        .frame(width: 100)
                    
                    Text("\(String(format: "%.0f", state.translation.height))")
                        .frame(width: 100)
                }
                
                Divider()
                
                HStack {
                    Text("Velocity:")
                        .bold()
                        .fixedSize()
                    
                    Spacer()
                    
                    Text("\(String(format: "%.0f", state.velocity.width))")
                        .frame(width: 100)
                    
                    Text("\(String(format: "%.0f", state.velocity.height))")
                        .frame(width: 100)
                }
                
                Divider()
                
                HStack {
                    Text("Acceleration:")
                        .bold()
                        .fixedSize()
                    
                    Spacer()
                    
                    Text("\(String(format: "%.0f", state.acceleration.width))")
                        .frame(width: 100)
                    
                    Text("\(String(format: "%.0f", state.acceleration.height))")
                        .frame(width: 100)
                }
                
                Divider()
            }
            
            HStack {
                Toggle(isOn: $canLock, label: {Text("Can Lock")})
                    .frame(maxWidth: 150)
                
                Spacer()
                
                Text(state.isLocked ? "Locked" : "Not Locked")
                
                Spacer()
            }
        }
        .offset(x: 0, y: -200)
        .padding(.horizontal, 30)
    }
    
    var body: some View {
        Joystick(state: $state, radius: 50, canLock: canLock, isDisabled: false)
            .background(
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 50, height: 50)
                    .rotationEffect(angle)
                    .offset(rectOffset)
                    .onReceive(timer, perform: { (time) in
                        if state.translation != .zero {
                            let scale = 5 * sqrt(state.translation.magnitudeSquared) / 50.0
                            let x = scale * cos(state.angle.radians)
                            let y = scale * sin(state.angle.radians)
                            rectOffset += CGSize(width: x, height: y)
                        }
                        
                        if state.isLocked {
                            angle += Angle(degrees: 1)
                        }
                    })
            )
            .overlay(overlay)
            .navigationTitle("Joystick")
    }
}

struct JoystickExample_Previews: PreviewProvider {
    static var previews: some View {
        JoystickExample()
    }
}
