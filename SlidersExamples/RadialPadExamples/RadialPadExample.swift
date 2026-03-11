// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

public struct Pentagon: Shape {
    /// Creates a square bottomed pentagon.
    public init() {}
    
    var insetAmount: CGFloat = 0
    
    public func path(in rect: CGRect) -> Path {
        let insetRect: CGRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let w = insetRect.width
        let h = insetRect.height
        
        return Path { path in
            path.move(to:    CGPoint(x: w/2, y:   0))
            path.addLine(to: CGPoint(x:   0, y: h/2))
            path.addLine(to: CGPoint(x:   0, y:   h))
            path.addLine(to: CGPoint(x:   w, y:   h))
            path.addLine(to: CGPoint(x:   w, y: h/2))
            path.closeSubpath()
        }
        .offsetBy(dx: insetAmount, dy: insetAmount)
    }
}

extension Pentagon: InsettableShape {
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

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
        }
        .frame(width: strokeWidth/2, height: 0.66*strokeWidth)
        .offset(x: 0, y: 0.16*strokeWidth-1.5)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
                
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white)
            }
            .frame(width: proxy.size.width)
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
        ZStack {
            Circle()
                .fill(Color.white)
            
            Circle()
                .inset(by: 6)
                .fill(
                    Color(
                        hue: configuration.angle.degrees/360,
                        saturation: configuration.radialOffset,
                        brightness: brightness)
                )
        }
        .frame(width: 45, height: 45)
    }
    
    func makeTrack(configuration: RadialPadConfiguration) -> some View {
        ZStack {
            Circle()
                .fill(Color(hue: 0, saturation: 0, brightness: brightness))
            
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
            RadialPad(
                offset: $saturation,
                angle: Binding(
                    get: { Angle(degrees: hue*360) },
                    set: { hue = $0.degrees/360 })
            )
            .radialPadStyle(SaturationHueRadialPad(brightness: brightness))
            
            LSlider($brightness, range: 0...1, angle: .zero)
                .linearSliderStyle(
                    BrightnessSliderStyle(
                        hue: hue,
                        saturation: saturation,
                        brightness: brightness,
                        strokeWidth: sliderHeight)
                )
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
        }
        .navigationTitle("Circular HSB Picker")
    }
}

struct RadialPadExample_Previews: PreviewProvider {
    static var previews: some View {
        CircularHSBPickerExample()
    }
}
