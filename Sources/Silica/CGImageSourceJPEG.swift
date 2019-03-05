//
//  CGImageSourceJPEG.swift
//  Cairo
//
//  Created by Max Liberman on 3/5/19.
//

#if os(macOS)
import Darwin.C.math
#elseif os(Linux)
import Glibc
#endif

import struct Foundation.Data
import Cairo

public final class CGImageSourceJPEG: CGImageSource {

    // MARK: - Class Properties

    public static let typeIdentifier = "public.jpeg"

    // MARK: - Properties

    public let surface: Cairo.Surface.Image

    // MARK: - Initialization

    public init?(data: Data) {

        guard let surface = try? Cairo.Surface.Image(jpeg: data)
            else { return nil }

        self.surface = surface
    }

    public init?(fromFile path: String) {

        guard let surface = try? Cairo.Surface.Image.jpeg(fromFile: path)
            else { return nil }

        self.surface = surface
    }

    // MARK: - Methods

    public func createImage(at index: Int) -> CGImage? {

        let image = CGImage(surface: surface)

        return image
    }
}
