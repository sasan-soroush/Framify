//
//  Extension + NSButton.swift
//  VideoSpliter
//
//  Created by Sasan Soroush on 1/24/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation
import Cocoa
extension NSButton {

    func set(textColor color: NSColor) {
        let newAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
        let range = NSRange(location: 0, length: attributedTitle.length)

        newAttributedTitle.addAttributes([
            .foregroundColor: color,
        ], range: range)

        attributedTitle = newAttributedTitle
    }
}
