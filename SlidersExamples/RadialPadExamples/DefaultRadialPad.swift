//
//  DefaultRadialPad.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders

struct DefaultRadialPad: View {
    @State var radius: Double = 0.4
    @State var angle: Angle = .zero
    var body: some View {
        ZStack {
            Color(white: 0.2)
            RadialPad(offset: $radius, angle: $angle)
            .frame(width: 200, height: 200)
        }.navigationBarTitle("Default RadialPad Style")
    }
}

struct DefaultRadialPad_Previews: PreviewProvider {
    static var previews: some View {
        DefaultRadialPad()
    }
}
