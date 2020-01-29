//
//  Extension + NSImage.swift
//  VideoSpliter
//
//  Created by Sasan Soroush on 1/24/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation
import Cocoa
import AppKit


extension NSImage {
    
    func save(as fileName: String, fileType: NSBitmapImageRep.FileType = .jpeg, at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath) , completion : @escaping (Bool) -> ()){
        guard let tiffRepresentation = tiffRepresentation, directory.isDirectory, !fileName.isEmpty else {
            completion(false)
            return
        }
        do {
            try NSBitmapImageRep(data: tiffRepresentation)?
                .representation(using: fileType, properties: [:])?
                .write(to: directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension))
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
}


extension NSBitmapImageRep.FileType {
    var pathExtension: String {
        switch self {
        case .bmp:
            return "bmp"
        case .gif:
            return "gif"
        case .jpeg:
            return "jpg"
        case .jpeg2000:
            return "jp2"
        case .png:
            return "png"
        case .tiff:
            return "tif"
        @unknown default:
             return ""
        }
    }
}

