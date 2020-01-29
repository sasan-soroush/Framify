//
//  Extension + String.swift
//  Framify
//
//  Created by New User on 1/27/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation

extension String {
    func createVaildPathString() -> String {
        let pathString = "file://\(self)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
        return pathString
    }
}
