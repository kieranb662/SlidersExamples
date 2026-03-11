// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

struct Triangle: Shape {
    private var insetAmount: CGFloat = 0
    var leftEdgeCurvature: CGFloat
    var rightEdgeCurvature: CGFloat
    var bottomEdgeCurvature: CGFloat
    
    /// Creates a Triangle with congreunt left and right edges.
    /// If the containing rectangle is a square then the Triangle will be equilateral,
    ///
    /// - Parameters:
    ///   - leftEdgeCurvature: The curvature value of the left edge positive values curve the edge inwards while postive values curve outwards
    ///   - rightEdgeCurvature: The curvature value of the right edge positive values curve the edge inwards while postive values curve outwards
    ///   - bottomEdgeCurvature: The curvature value of the top edge positive values curve the edge inwards while postive values curve outwards
    init(leftEdgeCurvature: CGFloat = 0,
         rightEdgeCurvature: CGFloat = 0,
         bottomEdgeCurvature: CGFloat = 0) {
        self.leftEdgeCurvature = leftEdgeCurvature
        self.rightEdgeCurvature = rightEdgeCurvature
        self.bottomEdgeCurvature = bottomEdgeCurvature
    }
    
    func path(in rect: CGRect) -> Path {
        let insetRect: CGRect = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let w = insetRect.width
        let h = insetRect.height
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: h))
            path.addQuadCurve(to: CGPoint(x: w/2, y: 0),
                              control: CGPoint(x: w*leftEdgeCurvature/4 + w/4, y: h/2))
            path.addQuadCurve(to: CGPoint(x: w, y: h),
                              control: CGPoint(x: 3*w/4 - w*rightEdgeCurvature/4, y: h/2))
            path.addQuadCurve(to: CGPoint(x: 0, y: h),
                              control: CGPoint(x: w/2, y: h - h*bottomEdgeCurvature/4))
            path.closeSubpath()
        }
        .offsetBy(dx: insetAmount, dy: insetAmount)
    }
}

extension Triangle: InsettableShape {
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

extension Triangle {
    public init(curvature: CGFloat = 0) {
        self.leftEdgeCurvature = curvature
        self.rightEdgeCurvature = curvature
        self.bottomEdgeCurvature = curvature
    }
}

extension Triangle {
    /// A Triangle that is curved to look like the tip of a bullet
    public static func bulletTip() -> Triangle {
        Triangle(leftEdgeCurvature: -1,
                 rightEdgeCurvature: -1,
                 bottomEdgeCurvature: 0)
    }
}

struct AngleSliderStyle: RSliderStyle {
    func makeThumb(configuration: RSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                Triangle()
                    .fill(Color.white)
                    .contentShape(Triangle())
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: proxy.size.height/2, height: proxy.size.height/3)
                    .offset(x: -proxy.size.height/6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(configuration.angle)
        }
    }
    
    func makeTrack(configuration: RSliderConfiguration) -> some View {
        Circle()
            .fill(Color.gray)
    }
}

struct LengthSliderStyle: LSliderStyle {
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        Pentagon()
            .stroke(configuration.isActive ? Color.green : Color.blue)
            .frame(width: 30, height: 35)
            .offset(x: 0, y: 2.5)
            .contentShape(Pentagon())
            .rotationEffect(configuration.angle)
    }
    
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                TickMarks(spacing: proxy.size.width/20, ticks: 20)
                    .stroke(Color.white)
                    .rotationEffect(configuration.angle)
                    .mask(RoundedRectangle(cornerRadius: 5))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray)
            )
        }
    }
}

struct LSliderExample: View {
    @State var value: Double = 0
    @State var angle: Double = 0
    @State var width: Double = 100
    @State var height: Double = -200
    let spacing: CGFloat = 30
    let angleSliderRadius: CGFloat = 90
    
    var body: some View {
        ZStack {
            Color(white: 0.2)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: spacing) {
                    LSlider($height, range: -400...(-1), angle: Angle(degrees: 90))
                        .frame(width: 40, height: 400)
                        .linearSliderStyle(LengthSliderStyle())
                    
                    LSlider($value, range: 0...1, angle: Angle(degrees: angle))
                        .padding(20)
                        .frame(width: CGFloat(width), height: CGFloat(-height))
                        .border(Color.blue)
                }
                .offset(x: angleSliderRadius/4)
                
                HStack(spacing: 0) {
                    RSlider($angle, range: 0...360)
                        .frame(width: angleSliderRadius, height: angleSliderRadius)
                        .radialSliderStyle(AngleSliderStyle())
                    
                    LSlider($width, range: 1...260, angle: .zero)
                        .frame(height: 40)
                        .linearSliderStyle(LengthSliderStyle())
                }
            }
            .frame(width: 350)
        }
        .navigationTitle("LSlider")
    }
}

struct LSliderExample_Previews: PreviewProvider {
    static var previews: some View {
        LSliderExample()
    }
}
