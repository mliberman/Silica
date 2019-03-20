//
//  Image.swift
//  Silica
//
//  Created by Alsey Coleman Miller on 5/11/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import struct Foundation.CGFloat
import struct Foundation.CGSize
import struct Foundation.Data
import Cairo

/// Represents bitmap images and bitmap image masks, based on sample data that you supply. 
/// A bitmap (or sampled) image is a rectangular array of pixels, 
/// with each pixel representing a single sample or data point in a source image.
public final class CGImage {
    
    // MARK: - Properties
    
    public var width: Int {
        return surface.width
    }
    
    public var height: Int {
        return surface.height
    }

    public var size: CGSize {
        return CGSize(width: width, height: height)
    }

    public var scale: CGFloat {
        return 1.0
    }
    
    /// The cached Cairo surface for this image.
    internal let surface: Cairo.Surface.Image
    
    // MARK: - Initialization
    
    internal init(surface: Cairo.Surface.Image) {
        self.surface = surface
    }
}

extension CGImage {

    public convenience init?(contentsOfFile path: String) {
        guard let surface = try? Cairo.Surface.Image(contentsOfFile: path) else { return nil }
        self.init(surface: surface)
    }

    public convenience init?(data: Data) {
        guard let surface = try? Cairo.Surface.Image(data: data) else { return nil }
        self.init(surface: surface)
    }

    public func pngData() -> Data? {
        return try? surface.writePNG()
    }

    public func jpegData(withQuality quality: Int32) -> Data? {
        return try? surface.writeJPEG(withQuality: quality)
    }

    public func jpegData(compressionQuality: CGFloat) -> Data? {
        return jpegData(withQuality: Int32(round(100.0 * Double(compressionQuality))))
    }

    public func masking(_ mask: CGImage) -> CGImage? {
        guard
            let surface = try? Surface.Image(
                format: surface.format ?? .argb32,
                width: width,
                height: height
            ),
            let context = try? CGContext(
                surface: surface,
                size: size
            )
            else { return nil }
        context.draw(self, mask: mask, in: context.bounds)
        return context.makeImage()
    }
}
