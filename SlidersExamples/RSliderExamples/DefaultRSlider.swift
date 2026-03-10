// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

struct DefaultRSlider: View {
    @State var value: Double = 0.5
    
    var body: some View {
        ZStack {
            Color(white: 0.2)
            
            RSlider($value)
                .frame(width: 200, height: 200)
        }
        .navigationTitle("Default RSlider Style")
    }
}

struct DefaultRSlider_Previews: PreviewProvider {
    static var previews: some View {
        DefaultRSlider()
    }
}
