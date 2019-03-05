//
//  CGAffineTransform.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 5/8/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import Cairo
import CCairo
import Foundation

#if os(macOS)

import struct CoreGraphics.CGAffineTransform
public typealias CGAffineTransform = CoreGraphics.CGAffineTransform

#else

/// Affine Transform
public struct CGAffineTransform: Hashable, Codable {
    
    // MARK: - Properties
    
    public var a, b, c, d, tx, ty: CGFloat
    
    // MARK: - Initialization
    
    public init(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, tx: CGFloat, ty: CGFloat) {
        
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }
    
    public static let identity = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)

    public init(uniformScale scale: CGFloat) {
        self.init(a: scale, b: 0.0, c: 0.0, d: scale, tx: 0.0, ty: 0.0)
    }

    public init(scaleX x: CGFloat, y: CGFloat) {
        self.init(a: x, b: 0.0, c: 0.0, d: y, tx: 0.0, ty: 0.0)
    }

    public init(translationX x: CGFloat, y: CGFloat) {
        self.init(a: 1.0, b: 0.0, c: 0.0, d: 1.0, tx: x, ty: y)
    }

    public init(rotationAngle: CGFloat) {
        self.init(
            a: cos(rotationAngle),
            b: sin(rotationAngle),
            c: -sin(rotationAngle),
            d: cos(rotationAngle),
            tx: 0.0,
            ty: 0.0
        )
    }

    public func concatenating(_ other: CGAffineTransform) -> CGAffineTransform {
        return CGAffineTransform(
            a: self.a * other.a + self.b * other.c,
            b: self.a * other.b + self.b * other.d,
            c: self.c * other.a + self.d * other.c,
            d: self.c * other.b + self.d * other.d,
            tx: self.tx * other.a + self.ty * other.c + other.tx,
            ty: self.tx * other.b + self.ty * other.d + other.ty
        )
    }

    public func rotated(by angle: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(rotationAngle: angle).concatenating(self)
    }

    public func scaledBy(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(scaleX: x, y: y).concatenating(self)
    }

    public func scaled(by scale: CGFloat) -> CGAffineTransform {
        return self.scaledBy(x: scale, y: scale)
    }

    public func translatedBy(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return CGAffineTransform(translationX: x, y: y).concatenating(self)
    }
}

#endif
    
// MARK: - Geometry Math

// Immutable math

public protocol CGAffineTransformMath {
    
    func applying(_ transform: CGAffineTransform) -> Self
}

// Mutable versions

public extension CGAffineTransformMath {
    
    @inline(__always)
    mutating func apply(_ transform: CGAffineTransform) {
        
        self = self.applying(transform)
    }
}

// Implementations

extension CGPoint: CGAffineTransformMath {
    
    @inline(__always)
    public func applying(_ t: CGAffineTransform) -> CGPoint {
        
        return CGPoint(x: t.a * x + t.c * y + t.tx,
                       y: t.b * x + t.d * y + t.ty)
    }
}

extension CGSize: CGAffineTransformMath {
    
    @inline(__always)
    public func applying( _ transform: CGAffineTransform) -> CGSize  {
        
        var newSize = CGSize(width:  transform.a * width + transform.c * height,
                             height: transform.b * width + transform.d * height)
        
        if newSize.width < 0 { newSize.width = -newSize.width }
        if newSize.height < 0 { newSize.height = -newSize.height }
        
        return newSize
    }
}

// MARK: - Cairo Conversion

extension CGAffineTransform: CairoConvertible {
    
    public typealias CairoType = Cairo.Matrix
    
    @inline(__always)
    public init(cairo matrix: CairoType) {
        
        self.init(a: CGFloat(matrix.xx),
                  b: CGFloat(matrix.xy),
                  c: CGFloat(matrix.yx),
                  d: CGFloat(matrix.yy),
                  tx: CGFloat(matrix.x0),
                  ty: CGFloat(matrix.y0))
    }
    
    @inline(__always)
    public func toCairo() -> CairoType {
        
        var matrix = Matrix()
        
        matrix.xx = Double(a)
        matrix.xy = Double(b)
        matrix.yx = Double(c)
        matrix.yy = Double(d)
        matrix.x0 = Double(tx)
        matrix.y0 = Double(ty)
        
        return matrix
    }
}

