//
//  MainViewController.swift
//  VideoSpliter
//
//  Created by Sasan Soroush on 1/23/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

class MainViewController: NSViewController {
    
    
    @IBOutlet weak var videoLabel: NSTextField!
    @IBOutlet weak var locationLabel: NSTextField!
    @IBOutlet weak var videoFramesCountLabel: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var maximumFramesTF: NSTextField!
    @IBOutlet weak var activity: KRActivityIndicatorView!

    
    private var videoPath = ""
    private var player:AVPlayer?
    var savePath = ""
    var videoFrameCount : Int?
    
    lazy var loadingView : NSView = {
        let view = NSView(frame: NSRect(x: 0, y: self.view.frame.height-5, width: 0, height: 5))
        view.wantsLayer = true
        view.layer?.backgroundColor = #colorLiteral(red: 0, green: 0.9803921569, blue: 0.5725490196, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension MainViewController {
    fileprivate func setupView() {
        startButton.bezelStyle = .roundRect
        startButton.isBordered = false //Important
        startButton.wantsLayer = true
        startButton.layer?.cornerRadius = 4
        startButton.frame.size.height = 40
        startButton.title = Strings.startRender
        startButton.layer?.backgroundColor = #colorLiteral(red: 0, green: 0.9803921569, blue: 0.5725490196, alpha: 1)
        startButton.set(textColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1))
        activity.color = #colorLiteral(red: 0, green: 0.9803921569, blue: 0.5725490196, alpha: 1)
        activity.type = .ballScaleMultiple
        maximumFramesTF.focusRingType = .none
    }
    
    private func startLoading() {
        view.addSubview(loadingView)
        disableButton()
    }
    private func stopLoading() {
        loadingView.removeFromSuperview()
        enableButton()
    }
    
    private func enableButton() {
        startButton.isEnabled = true
        startButton.alphaValue = 1.0
    }
    
    private func disableButton() {
        startButton.isEnabled = false
        startButton.alphaValue = 0.5
    }
}

extension MainViewController {
    
    private func setVideoCount(path : String){
        if let url = URL(string: path) {
            activity.startAnimating()
            disableButton()
            DispatchQueue.global(qos: .background).async {
                let framesCount = self.getFramesCount(url: url)
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.enableButton()
                    var string = Strings.frameCountUnavailable
                    if let count = framesCount  {
                        self.videoFrameCount = count
                        string = Strings.videoFrameCount(count: count)
                    }
                    self.videoFramesCountLabel.stringValue = string
                }
            }
        }
    }
    
    @IBAction func PickeImageTapped(_ sender: Any) {
        
        let dialog = NSOpenPanel();
        dialog.title                   = Strings.chooseVideo;
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories    = false;
        dialog.allowedFileTypes        = Constants.supportedVideoFormats;
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if (result != nil) {
                let path: String = result!.path
                videoPath = path.createVaildPathString()
                videoLabel.stringValue = path
                setVideoCount(path: videoPath)
            }
        } else {
            return
        }
    }
    
    @IBAction func ChooseLocationTapped(_ sender: NSButton) {
        
        let dialog = NSOpenPanel();
        dialog.title                   = Strings.chooseLocation;
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories    = true;
        dialog.canChooseFiles          = false;
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if (result != nil) {
                let path: String = result!.path
                savePath = path.createVaildPathString()
                locationLabel.stringValue = path
            }
        } else {
            return
        }
    }
    
    fileprivate func startRenderingFrames() {
        if let url = URL(string: videoPath) {
            self.startLoading()
            let preferredFrameCount = Int(self.maximumFramesTF.stringValue)!
            DispatchQueue.global(qos: .background).async {
                self.renderFrames(url: url, maximumFramesCount: preferredFrameCount, progressHandler: { (renderedFrameCount) in
                    DispatchQueue.main.async {
                        let renderProgress : CGFloat = CGFloat(renderedFrameCount)/CGFloat(self.videoFrameCount!)
                        self.loadingView.frame.size.width = self.view.frame.width * renderProgress
                    }
                }) {
                    DispatchQueue.main.async {
                        self.stopLoading()
                        guard let url = URL(string: self.savePath) else { return }
                        NSWorkspace.shared.activateFileViewerSelecting([url])
                    }
                }
            }
        } else {
            DialogManager.shared.couldNotFindVideo()
        }
    }
}

extension MainViewController {
    @IBAction func StartRendering(_ sender: NSButton) {
        
        if videoPath == "" {
            DialogManager.shared.chooseVideo()
            return
        }
        
        if savePath == "" {
            DialogManager.shared.chooseSaveLocation()
            return
        }
        
        if maximumFramesTF.stringValue == "" {
            DialogManager.shared.chooseFrameCount()
            return
        }
        
        if Int(maximumFramesTF.stringValue) == nil {
            DialogManager.shared.incorrectFramesFormat()
            return
        }
        
        if Int(maximumFramesTF.stringValue)! < 5 {
            DialogManager.shared.minimumFrameCountError()
            return
        }
        
        if videoFrameCount == nil || videoFrameCount == 0 {
            DialogManager.shared.videoFrameCountNotCalculated()
            return
        }
        //it should be less that half of the actual video frames
        if Int(maximumFramesTF.stringValue)! > videoFrameCount!/2 {
            DialogManager.shared.preferredFrameCountIsMoreThanVideoItself(maximum: videoFrameCount!/2)
            return
        }
        
        startRenderingFrames()
        
    }
}


