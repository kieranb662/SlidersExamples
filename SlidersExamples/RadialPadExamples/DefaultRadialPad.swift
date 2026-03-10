// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
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
        }
        .navigationTitle("Default RadialPad Style")
    }
}

struct DefaultRadialPad_Previews: PreviewProvider {
    static var previews: some View {
        DefaultRadialPad()
    }
}
