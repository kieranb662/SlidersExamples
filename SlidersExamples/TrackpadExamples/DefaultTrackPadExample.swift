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
    var body: some View {
        TrackPad($value)
            .frame(width: 200, height: 300)
        .navigationBarTitle("Default TrackPad")
    }
}

struct DefaultTrackPadExample_Previews: PreviewProvider {
    static var previews: some View {
        DefaultTrackPadExample()
    }
}
