//
//  RadialPadExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders
import Shapes



struct BrightnessSliderStyle: LSliderStyle {
    let hue: Double
    let saturation: Double
    let brightness: Double
    var color: Color { Color(hue: hue, saturation: saturation, brightness: brightness) }
    let strokeWidth: CGFloat
    var gradient: Gradient {
        Gradient(colors: [Color(hue: hue, saturation: saturation, brightness: 0),
                          Color(hue: hue, saturation: saturation, brightness: 1)])
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        ZStack {
            Pentagon()
                .fill(color)
            Pentagon()
                .stroke(Color.white, style: .init(lineWidth: 3, lineJoin: .round))
        }.frame(width: strokeWidth/2, height: 0.66*strokeWidth)
            .offset(x: 0, y: 0.16*strokeWidth-1.5)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: self.gradient, startPoint: .leading, endPoint: .trailing))
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white)
            }.frame(width: proxy.size.width)
        }
    }
}

struct SaturationHueRadialPad: RadialPadStyle {
    let brightness: Double
    var hueColors: [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: brightness)
        }
    }
    
    func makeThumb(configuration: RadialPadConfiguration) -> some View {
        let color = Color(hue: (configuration.angle.degrees/360), saturation: configuration.radialOffset, brightness: self.brightness)
        return ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .inset(by: 6)
                .fill(color)
        }.frame(width: 45, height: 45)
    }
    
    func makeTrack(configuration: RadialPadConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color(hue: 0, saturation: 0, brightness: self.brightness))
            HueCircleView()
                .blendMode(.plusDarker)
            Circle()
                .stroke(Color.white, lineWidth: 2)
        }
    }
}

struct CircularHSBColorPicker: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    var sliderHeight: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 20) {
            RadialPad(offset: $saturation,
                      angle: Binding(get: { Angle(degrees: self.hue*360) },
                                     set: { self.hue = $0.degrees/360 }))
                .radialPadStyle(SaturationHueRadialPad(brightness: brightness))
            LSlider($brightness, range: 0...1, angle: .zero)
                .linearSliderStyle(BrightnessSliderStyle(hue: hue, saturation: saturation, brightness: brightness, strokeWidth: sliderHeight))
                .frame(height: sliderHeight)
        }
    }
}

struct CircularHSBPickerExample: View {
    @State var hue: Double = 0.5
    @State var saturation: Double = 0.5
    @State var brightness: Double = 0.5
    
    var body: some View {
        ZStack {
            Color(white: 0.2)
            CircularHSBColorPicker(hue: $hue, saturation: $saturation, brightness: $brightness)
                .frame(height: 400)
                .padding(50)
        }.navigationBarTitle("Circular HSB Picker")
    }
}

struct RadialPadExample_Previews: PreviewProvider {
    static var previews: some View {
        CircularHSBPickerExample()
    }
}
