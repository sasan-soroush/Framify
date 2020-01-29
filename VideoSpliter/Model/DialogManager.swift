//
//  DialogManager.swift
//  Framify
//
//  Created by New User on 1/27/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Cocoa

struct DialogManager {
    static let shared = DialogManager()
    
    func chooseSaveLocation() {
        dialogOKCancel(title: Strings.chooseSaveLocationTitle, body: Strings.chooseSaveLocationBody)
    }
    
    func chooseVideo() {
        dialogOKCancel(title: Strings.chooseVideoTitle, body: Strings.chooseVideoBody)
    }
    
    func chooseFrameCount() {
        dialogOKCancel(title: Strings.chooseFrameCountTitle, body: Strings.chooseFrameCountBody)
    }
    
    func incorrectFramesFormat() {
        dialogOKCancel(title: Strings.incorrectFramesFormatTitle, body: Strings.incorrectFramesFormatBody)
    }
    
    func minimumFrameCountError() {
        dialogOKCancel(title: Strings.minimumFrameCountErrorTitle, body: Strings.minimumFrameCountErrorBody)
    }
    
    func couldNotFindVideo() {
        dialogOKCancel(title: Strings.couldNotFindVideoTitle, body: Strings.couldNotFindVideoBody)
    }
    
    func saveLoactionAgain() {
        dialogOKCancel(title: Strings.saveLocationAgainTitle, body: Strings.saveLocationAgainBody)
    }
    
    func videoFrameCountNotCalculated() {
        dialogOKCancel(title: Strings.videoFrameCountNotCalculatedTitle, body: Strings.videoFrameCountNotCalculatedBody)
    }
    
    func preferredFrameCountIsMoreThanVideoItself(maximum : Int) {
        dialogOKCancel(title: Strings.preferredFrameCountIsMoreThanVideoItselfTitle, body: Strings.preferredFrameCountIsMoreThanVideoItselfBody(videoFrameCount: maximum))
    }
    
    private func dialogOKCancel(title: String, body: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: Strings.ok)
        alert.addButton(withTitle: Strings.cancel)
        alert.runModal()
    }
}
