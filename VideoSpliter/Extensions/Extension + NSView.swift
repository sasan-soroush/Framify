//
//  Extension + UIView.swift
//  VideoSpliter
//
//  Created by Sasan Soroush on 1/24/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//
import Cocoa

extension NSView {
    var image: NSImage? {
        return NSImage(data: dataWithPDF(inside: bounds))
    }
}
