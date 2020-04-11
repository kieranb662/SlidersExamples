//
//  LSliderExample.swift
//  SlidersExamples
//
//  Created by Kieran Brown on 4/11/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import Sliders
import Shapes

struct AngleSliderStyle: RSliderStyle {
    func makeThumb(configuration: RSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                Triangle()
                    .fill(Color.white)
                    .contentShape(Triangle())
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: proxy.size.height/2, height: proxy.size.height/3)
                    .offset(x: -proxy.size.height/4)
            }.rotationEffect(configuration.angle )
        }
    }
    func makeTrack(configuration: RSliderConfiguration) -> some View {
        Circle().fill(Color.gray)
    }
}

struct LengthSliderStyle: LSliderStyle {
    func makeThumb(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                Pentagon().stroke(configuration.isActive ? Color.green : Color.blue)
                    .frame(width: 30, height: 35)
                    .offset(x: 0, y: 2.5)
            }.contentShape(Pentagon())
                .rotationEffect(configuration.angle)
        }
    }
    func makeTrack(configuration: LSliderConfiguration) -> some View {
        GeometryReader { proxy in
            ZStack {
                TickMarks(spacing: abs(configuration.angle.degrees) == 90 ? proxy.size.height/20 : proxy.size.width/20, ticks: 20)
                    .stroke(Color.white)
                    .frame(width: abs(configuration.angle.degrees) == 90 ? proxy.size.height : proxy.size.width, height: abs(configuration.angle.degrees) == 90 ? proxy.size.width : proxy.size.height).clipped()
            }.overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                .rotationEffect(configuration.angle)
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
                    
                }.offset(x: angleSliderRadius/4)
                HStack(spacing: 0) {
                    RSlider($angle, range: 0...360)
                        .frame(width: angleSliderRadius, height: angleSliderRadius).radialSliderStyle(AngleSliderStyle())
                    LSlider($width, range: 1...260, angle: .zero)
                        .frame(height: 40)
                        .linearSliderStyle(LengthSliderStyle())
                }
            }
            .frame(width: 350)
        }
        .navigationBarTitle("LSlider")
    }
}

struct LSliderExample_Previews: PreviewProvider {
    static var previews: some View {
        LSliderExample()
    }
}
