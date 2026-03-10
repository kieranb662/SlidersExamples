//
//  DefaultTrackPadExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
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
