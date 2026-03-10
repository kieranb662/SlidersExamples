// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

struct RGBSliderStyle: LSliderStyle {
    enum ColorType: String, CaseIterable {
        case red
        case green
        case blue
    }
    var strokeWidth: CGFloat
    var type: ColorType
    var color: (red: Double, green: Double, blue: Double)
    var colors: [Color] {
        switch type {
        case .red:
            return [Color(red: 0, green: color.green, blue: color.blue),
                    Color(red: 1, green: color.green, blue: color.blue)]
        case .green:
            return [Color(red: color.red, green: 0, blue: color.blue),
                    Color(red: color.red, green: 1, blue: color.blue)]
        case .blue:
            return [Color(red: color.red, green: color.green, blue: 0),
                    Color(red: color.red, green: color.green, blue: 1)]
        }
    }
    
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        let currentColor: Color =  {
            switch type {
            case .red:
                return Color(red: Double(configuration.pctFill), green: 0, blue: 0)
            case .green:
                return Color(red: 0, green: Double(configuration.pctFill), blue: 0)
            case .blue:
                return Color(red: 0, green: 0, blue: Double(configuration.pctFill))
            }
        }()
        
        
        return ZStack {
            Circle()
                .fill(Color.white)
                .shadow(radius: 2)
            Circle()
                .fill(currentColor)
                .scaleEffect(0.8)
        }
        .frame(width: strokeWidth, height: strokeWidth)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        let style: StrokeStyle = .init(lineWidth: strokeWidth)
        let gradient = LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        
        return GeometryReader { geo in
            ZStack {
                AdaptiveLine(angle: configuration.angle)
                    .stroke(gradient, style: style)
                    .mask(Capsule())
                
                Capsule()
                    .stroke(Color.white)
                    .rotationEffect(configuration.angle)
            }
            .frame(width: geo.size.width + strokeWidth)
            .offset(x: -strokeWidth/2)
        }
    }
}

struct RGBColorPicker: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    
    var sliderHeights: CGFloat = 40
    
    func makeSlider( _ color: RGBSliderStyle.ColorType) -> some View {
        let value: Binding<Double> =  {
            switch color {
            case .red:      return $red
            case .blue:     return $blue
            case .green:    return $green
            }
        }()
        
        return LSlider(value, range: 0...1, angle: .zero)
            .linearSliderStyle(RGBSliderStyle(strokeWidth: sliderHeights, type: color, color: (red, green, blue)))
            .frame(height: sliderHeights)
    }
    
    var body: some View {
        VStack(spacing: 20){
            makeSlider( .red)
            makeSlider(.green)
            makeSlider(.blue)
        }
    }
}

struct RGBColorPickerExample: View {
    @State var red: Double = 0.2
    @State var green: Double = 0.5
    @State var blue: Double = 0.8
    var overlay: some View {
        VStack {
            Text("r: \(String(format: "%.0f", red*255))")
            Text("g: \(String(format: "%.0f", green*255))")
            Text("b: \(String(format: "%.0f", blue*255))")
            Text(Color(red: red, green: green, blue: blue).description)
        }
    }
    
    var body: some View {
        ZStack {

            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: red, green: green, blue: blue))
                    .frame(height: 300)
                    .shadow(radius: 3)
                    .overlay(self.overlay)
                
                RGBColorPicker(red: $red, green: $green, blue: $blue)
                    .frame(maxWidth: 300)
            }
            .padding(.horizontal, 40)
        }
        .padding(20)
        .background(Color(white: 0.2))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("RGB Color Picker")
    }
}

struct RGBColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        RGBColorPickerExample()
    }
}
