//
//  KnobStyleExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

struct KnobStyleExample: View {
    @State var value: Double = 0.5
    var body: some View {
        ZStack {
            Color(white: 0.2)
            RSlider($value)
            .radialSliderStyle(KnobStyle())
        }.navigationBarTitle("RSlider Knob Style")
    }
}

struct KnobStyleExample_Previews: PreviewProvider {
    static var previews: some View {
        KnobStyleExample()
    }
}
