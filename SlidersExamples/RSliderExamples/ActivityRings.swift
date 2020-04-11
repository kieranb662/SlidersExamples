//
//  RSliderExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
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
        let strokeStyle = StrokeStyle(lineWidth: width, lineCap: .butt)
        
        return Circle().trim(from: 0, to: CGFloat(configuration.pctFill))
            .stroke(color, style: strokeStyle)
        
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
        }.navigationBarTitle("Activity Rings")
    }
}

struct RSliderExample_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRingExample()
    }
}
