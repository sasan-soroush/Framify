//
//  Extension + Url.swift
//  VideoSpliter
//
//  Created by New User on 1/25/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
