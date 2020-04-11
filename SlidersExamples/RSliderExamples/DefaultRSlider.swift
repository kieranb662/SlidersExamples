//
//  DefaultRSlider.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

struct DefaultRSlider: View {
    @State var value: Double = 0.5
    var body: some View {
        ZStack {
            Color(white: 0.2)
            RSlider($value).frame(width: 200, height: 200)
        }.navigationBarTitle("Default RSlider Style")
    }
}

struct DefaultRSlider_Previews: PreviewProvider {
    static var previews: some View {
        DefaultRSlider()
    }
}
