// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

struct DefaultTrackPadExample: View {
    @State var value: CGPoint = .zero
    @State var x = 0.5
    @State var y = 0.5
    
    var body: some View {
        VStack {
            Text("CGPoint initializer")
            
            TrackPad($value)
                .frame(width: 200, height: 300)
            
            Text("Two Doubles Initializer")
            
            TrackPad(x: $x, y: $y)
                .frame(width: 200, height: 300)
            
        }
        .navigationTitle("Default TrackPad")
    }
}

struct DefaultTrackPadExample_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTrackPadExample()
    }
}
