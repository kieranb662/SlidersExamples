//
//  ContentView.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("LSlider")) {
                    NavigationLink("LSlider", destination: LSliderExample())
                    NavigationLink("RGB Color Picker", destination: RGBColorPickerExample())
                }
                Section(header: Text("RSlider")) {
                    NavigationLink("Default Style", destination: DefaultRSlider())
                    NavigationLink("Knob Style", destination: KnobStyleExample())
                    NavigationLink("Activity Rings", destination: ActivityRingExample())
                }
                Section(header: Text("OverflowSlider")) {
                    NavigationLink("OverflowSlider", destination: OverflowSliderExample())
                }
                
                Section(header: Text("TrackPad")) {
                    NavigationLink("Default Style", destination: DefaultTrackPadExample())
                    NavigationLink("Graph Style", destination: GraphStyleExample())
                    NavigationLink("HSB Color Picker", destination: HSBColorPickerExample())
                    
                }
                Section(header: Text("RadialPad")) {
                    NavigationLink("Default Style", destination: DefaultRadialPad())
                    NavigationLink("HSB Color Picker", destination: CircularHSBPickerExample())
                }
            
                Section(header: Text("Joystick")) {
                    NavigationLink("JoyStick", destination: JoystickExample())
                }
                
                
            }.navigationBarTitle("Sliders Examples")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
