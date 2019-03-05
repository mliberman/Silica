//
//  CGVector.swift
//  Cairo
//
//  Created by Max Liberman on 3/5/19.
//

import Foundation

#if os(macOS)

import struct CoreGraphics.CGVector
public typealias CGVector = CoreGraphics.CGVector

#else

public struct CGVector: Hashable, Codable {

    public var dx: CGFloat
    public var dy: CGFloat

    public init(dx: CGFloat, dy: CGFloat) {
        self.dx = dx
        self.dy = dy
    }
}

#endif
