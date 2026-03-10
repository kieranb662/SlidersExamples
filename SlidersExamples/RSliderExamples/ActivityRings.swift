// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders


struct ActivityRingStyle: RSliderStyle {
    var width: CGFloat
    var color: Color
    
    func makeThumb(configuration: RSliderConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(configuration.isActive ? color : Color.white)
            Circle()
                .stroke(configuration.isActive ? color : Color.gray)
        }
        .frame(width: width, height: width)
    }
    
    func makeTrack(configuration: RSliderConfiguration) -> some View {
        Circle()
            .trim(from: 0, to: CGFloat(configuration.pctFill))
            .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .butt))
    }
}

struct ActivityRingExample: View {
    @State var first: Double = 0.5
    @State var second: Double = 0.25
    @State var third: Double = 0.75
    let width: CGFloat = 60
    let startDiameter: CGFloat = 360
    
    var body: some View {
        ZStack {
            RSlider($first)
                .frame(width: startDiameter, height: startDiameter)
                .radialSliderStyle(ActivityRingStyle(width: width ,color: Color.green))
            
            RSlider($second)
                .frame(width: startDiameter-(2*width), height: startDiameter-(2*width))
                .radialSliderStyle(ActivityRingStyle(width: width, color: Color.blue))
            
            RSlider($third)
                .frame(width: startDiameter-(4*width), height: startDiameter-(4*width))
                .radialSliderStyle(ActivityRingStyle(width: width, color: Color.red))
        }
        .navigationTitle("Activity Rings")
    }
}

struct RSliderExample_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingExample()
    }
}
