// Swift toolchain version 6.0
// Running macOS version 26.3
// Created on 4/11/20.
//
// Author: Kieran Brown
//

import SwiftUI
import Sliders

public struct CrossHair: View {
    var color: Color
    var length: CGFloat
    
    func line(angle: CGFloat, proxy: GeometryProxy) -> some View {
        let midX = proxy.frame(in: .local).width/2
        let midY = proxy.frame(in: .local).height/2
        
        return Path { p in
            p.move(to: CGPoint(x: midX, y: midY-9))
            p.addLine(to: CGPoint(x: midX, y: midY+length))
        }
        .rotation(Angle(degrees: Double(angle)), anchor: .top)
        .stroke(color, lineWidth: 5)
    }
    
    /// # Crosshair
    /// - parameters:
    ///    - color  The color of the crosshair
    ///    - lineLength: The length of each of the for lines that converge to the center of the crosshair.
    public init(color: Color = .black, lineLength: CGFloat = 20) {
        self.color = color
        self.length = lineLength
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(self.color, lineWidth: 4).frame(width: 40, height: 40)
                .overlay(
                    GeometryReader { (proxy: GeometryProxy) in
                        ZStack {
                            self.line(angle: 0, proxy: proxy)
                            self.line(angle: 90, proxy: proxy)
                            self.line(angle: 180, proxy: proxy)
                            self.line(angle: 270, proxy: proxy)
                        }
                        .offset(CGSize(width: 0, height: proxy.frame(in: .local).height/2))
                    }
                )
                .contentShape(Circle())
        }
    }
}

struct GraphStyle: TrackPadStyle {
    func makeThumb(configuration: TrackPadConfiguration) -> some View {
        CrossHair(color: Color.blue, lineLength: 20)
    }
    func makeTrack(configuration: TrackPadConfiguration) -> some View {
        CartesianGrid(xCount: 7, yCount: 7).stroke(Color.gray)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white)
            )
    }
}

struct GraphStyleExample: View {
    @State var value: CGPoint = .zero
    var body: some View {
        ZStack {
            Color(white: 0.2)
            
            TrackPad($value)
                .trackPadStyle(GraphStyle())
                .frame(width: 300, height: 300)
        }
        .navigationTitle("Graph Style Trackpad")
    }
}


public struct CartesianGrid: Shape {
    public var xCount: Int
    public var yCount: Int
    
    public init(xCount: Int, yCount: Int) {
        self.xCount = xCount
        self.yCount = yCount
    }
    
    public func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let rangeX = 1...xCount
        let rangeY = 1...yCount
        
        return Path { path in
            for i in rangeX {
                path.move(to: CGPoint(x: CGFloat(i)*w/CGFloat(self.xCount), y: 0))
                path.addLine(to: CGPoint(x: CGFloat(i)*w/CGFloat(self.xCount), y: h))
            }
            for j in rangeY {
                path.move(to: CGPoint(x: 0, y: CGFloat(j)*h/CGFloat(self.yCount)))
                path.addLine(to: CGPoint(x: w, y: CGFloat(j)*h/CGFloat(self.yCount)))
            }
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GraphStyleExample()
    }
}
