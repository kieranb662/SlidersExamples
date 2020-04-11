//
//  HueCircleView.swift
//  MyExamples
//
//  Created by Kieran Brown on 4/8/20.
//  Copyright © 2020 BrownandSons. All rights reserved.
//

import SwiftUI
import UIKit
import simd
import MetalKit



let shader = """
                    #include <metal_stdlib>
                    using namespace metal;

                    struct Vertex {
                        float4 position [[position]];
                        float4 color;
                    };

                    struct Uniforms {
                        float4x4 modelMatrix;
                    };

                    vertex Vertex vertex_func(constant Vertex *vertices [[buffer(0)]],
                                              constant Uniforms &uniforms [[buffer(1)]],
                                              uint vid [[vertex_id]]) {
                        float4x4 matrix = uniforms.modelMatrix;
                        Vertex in = vertices[vid];
                        Vertex out;
                        out.position = matrix * float4(in.position);
                        out.color = in.color;
                        return out;
                    }

                    fragment float4 fragment_func(Vertex vert [[stage_in]]) {
                        return vert.color;
                    }
"""

// FIXME: Shader Library needs to be created with the color picker
public class MetalView: NSObject, MTKViewDelegate {
    
    public var device: MTLDevice!
    var queue: MTLCommandQueue!
    var vertexBuffer: MTLBuffer!
    var uniformBuffer: MTLBuffer!
    var rps: MTLRenderPipelineState!
    var vertexData: [Vertex] = []

    
    override public init() {
        super.init()
        
        createVertexPoints()
        createBuffers()
        registerShaders()
    }
    
    func rgb(h: Float, s: Float, v: Float) -> (r: Float, g: Float, b: Float){
        if s == 0 { return (r: v, g: v, b: v) } // Achromatic grey
        
        let angle = Float(Int(h)%360)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return (r: v, g: t, b: p)
        case 1:
            return (r: q, g: v, b: p)
        case 2:
            return (r: p, g: v, b: t)
        case 3:
            return (r: p, g: q, b: v)
        case 4:
            return (r: t, g: p, b: v)
        default:
            return (r: v, g: p, b: q)
        }
    }
    
    fileprivate func createVertexPoints()  {
        func rads(forDegree d: Float)->Float32{
            return (Float.pi*d)/180
        }
        var vertices: [Vertex] = []
        
        let origin: vector_float4 = vector_float4([0, 0, 0, 1])
        
        for i in 0..<720 {
            let position: vector_float4 = vector_float4([cos(rads(forDegree: Float(i)))*2,sin(rads(forDegree: Float(i)))*2, 0, 1])
            let color = rgb(h: 720-Float(i), s: 1, v: 1)
            
            vertices.append(Vertex(pos: position, col: vector_float4([color.r, color.g, color.b, 1])))
            if (i+1)%2 == 0 {
                let col = rgb(h: 720-Float(i), s: 0, v: 1)
                let c: vector_float4 = vector_float4([col.r, col.g, col.b, 1])
                vertices.append(Vertex(pos: origin, col: c))
            }
        }
        self.vertexData = vertices
        
    }
    
    func createBuffers() {
        device = MTLCreateSystemDefaultDevice()
        queue = device.makeCommandQueue()
        self.createVertexPoints()
        
        
        vertexBuffer = device!.makeBuffer(bytes: vertexData, length: MemoryLayout<Vertex>.size * vertexData.count , options:[])
        uniformBuffer = device!.makeBuffer(length: MemoryLayout<Float>.size * 16, options: [])
        let bufferPointer = uniformBuffer.contents()
        memcpy(bufferPointer, Matrix().scalingMatrix(Matrix(), 0.5).m, MemoryLayout<Float>.size * 16)
    }
    
    func registerShaders() {
        let input: String?
        let vert_func: MTLFunction
        let frag_func: MTLFunction
        do {
            input = shader
            let library = try device.makeLibrary(source: input!, options: nil)
            let vert_func = library.makeFunction(name: "vertex_func")!
            let frag_func = library.makeFunction(name: "fragment_func")!
            let rpld = MTLRenderPipelineDescriptor()
            rpld.vertexFunction = vert_func
            rpld.fragmentFunction = frag_func
            rpld.colorAttachments[0].pixelFormat = .bgra8Unorm
            rps = try device!.makeRenderPipelineState(descriptor: rpld)
        } catch let e {
            Swift.print("\(e)")
        }
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        if let rpd = view.currentRenderPassDescriptor,
           let drawable = view.currentDrawable,
           let commandBuffer = queue.makeCommandBuffer(),
           let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd) {
            rpd.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
            commandEncoder.setRenderPipelineState(rps)
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
            commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertexData.count, instanceCount: 1)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}

struct Vertex {
    var position: vector_float4
    var color: vector_float4
    init(pos: vector_float4, col: vector_float4) {
        position = pos
        color = col
    }
}
struct Matrix {
    var m: [Float]
    
    init() {
        m = [1, 0, 0, 0,
             0, 1, 0, 0,
             0, 0, 1, 0,
             0, 0, 0, 1
        ]
    }
    
    func translationMatrix(_ matrix: Matrix, _ position: float3) -> Matrix {
        var matrix = matrix
        matrix.m[12] = position.x
        matrix.m[13] = position.y
        matrix.m[14] = position.z
        return matrix
    }
    
    func scalingMatrix(_ matrix: Matrix, _ scale: Float) -> Matrix {
        var matrix = matrix
        matrix.m[0] = scale
        matrix.m[5] = scale
        matrix.m[10] = scale
        matrix.m[15] = 1.0
        return matrix
    }
    
    
    func rotationMatrix(_ matrix: Matrix, _ rot: float3) -> Matrix {
        var matrix = matrix
        matrix.m[0] = cos(rot.y) * cos(rot.z)
        matrix.m[4] = cos(rot.z) * sin(rot.x) * sin(rot.y) - cos(rot.x) * sin(rot.z)
        matrix.m[8] = cos(rot.x) * cos(rot.z) * sin(rot.y) + sin(rot.x) * sin(rot.z)
        matrix.m[1] = cos(rot.y) * sin(rot.z)
        matrix.m[5] = cos(rot.x) * cos(rot.z) + sin(rot.x) * sin(rot.y) * sin(rot.z)
        matrix.m[9] = -cos(rot.z) * sin(rot.x) + cos(rot.x) * sin(rot.y) * sin(rot.z)
        matrix.m[2] = -sin(rot.y)
        matrix.m[6] = cos(rot.y) * sin(rot.x)
        matrix.m[10] = cos(rot.x) * cos(rot.y)
        matrix.m[15] = 1.0
        return matrix
    }
    
    func modelMatrix(matrix: Matrix) -> Matrix {
        var matrix = matrix
        matrix = rotationMatrix(matrix, float3(0.0, 0.0, 0.1))
        matrix = scalingMatrix(matrix, 0.25)
        matrix = translationMatrix(matrix, float3(0.0, 0.5, 0.0))
        return matrix
    }
}

struct HueCircleMetalView: UIViewRepresentable {
    typealias UIViewType = MTKView
    var size: CGSize
 
    var delegate: MetalView
    init(_ size: CGSize) {
        self.size = size
        self.delegate = MetalView()
    }
    
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), device: delegate.device)
        view.delegate = delegate
       
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        print("updated")
        
    }
}


struct HueCircleView: View {
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                HueCircleMetalView(proxy.size)
                .mask(Circle())
            }
        }
    }
}

struct HueCircleView_Previews: PreviewProvider {
    static var previews: some View {
        HueCircleView()
    }
}
