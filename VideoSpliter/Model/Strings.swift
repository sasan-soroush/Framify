//
//  Strings.swift
//  Framify
//
//  Created by New User on 1/27/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation

struct Strings {
    
    static let ok = "OK"
    static let cancel = "Cancel"
    static let startRender = "Start Rendering"
    static let stopRender = "Stop Rendering"
    static let chooseVideo = "Choose a video"
    static let chooseLocation = "Choose a location"
    static let frameCountUnavailable = "Video Frames Count : Unavailable"
    
    static func videoFrameCount(count : Int) -> String{
        return "Video Frames Count : \(count)"
    }
    
    static let chooseSaveLocationTitle = "Choose save location"
    static let chooseSaveLocationBody = "Please specify a directory to save frames."
    
    static let chooseVideoTitle = "Choose video"
    static let chooseVideoBody = "Please choose a video to extract frames from."
    
    static let chooseFrameCountTitle = "Choose frame count"
    static let chooseFrameCountBody = "Please choose your preferred maximum frames count."
    
    static let incorrectFramesFormatTitle = "Incorrect format"
    static let incorrectFramesFormatBody = "Please choose your preferred maximum frames count in numbers."
    
    static let minimumFrameCountErrorTitle = "Incorrect frame count"
    static let minimumFrameCountErrorBody = "minimum frame count allowed is 5."
    
    static let couldNotFindVideoTitle = "Could not find video"
    static let couldNotFindVideoBody = "Please choose video location again."
    
    static let saveLocationAgainTitle = "Something went wrong!"
    static let saveLocationAgainBody = "Please select save location again."
    
    static let videoFrameCountNotCalculatedTitle = "Something went wrong!"
    static let videoFrameCountNotCalculatedBody = "Please choose video again in order to calculate frames."
    
    static let preferredFrameCountIsMoreThanVideoItselfTitle = "Choose frame count correctly!"
    static func preferredFrameCountIsMoreThanVideoItselfBody(videoFrameCount : Int) -> String {
        return "Preferred frame count can't be more than \(videoFrameCount)"
    }
}
