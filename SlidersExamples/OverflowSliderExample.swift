//
//  OverflowSliderExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

struct OverflowSliderExample: View {
    @State var value: Double = 100
    var body: some View {
        VStack {
            Text("1. Try dragging the inside of the capsule and then release it as fast as you can ")
                .frame(height: 75)
            Text("2. After drag the blue thumb past the left or right edge of the capsule")
                .frame(height: 75)
            OverflowSlider(value: $value, range: -1000...1000, spacing: 20, isDisabled: false)
            .mask(Capsule())
                .overlay(Capsule().stroke(Color.blue))
            .frame(height: 50)
                .padding(.horizontal, 30)
        }.navigationBarTitle("Overflow Slider")
    }
}

struct OverflowSliderExample_Previews: PreviewProvider {
    static var previews: some View {
        OverflowSliderExample()
    }
}
