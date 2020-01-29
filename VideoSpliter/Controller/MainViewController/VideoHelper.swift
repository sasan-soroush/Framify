//
//  VideoHelper.swift
//  VideoSpliter
//
//  Created by Sasan Soroush on 1/26/20.
//  Copyright © 2020 Sasan Soroush. All rights reserved.
//

import Foundation
import AVFoundation
import Cocoa
extension MainViewController {
    fileprivate func saveFrame(_ sample: CMSampleBuffer?, _ frameCount: Int, _ url: URL,successHandler : @escaping (Bool)->()) {
        let img = imageFromSampleBuffer(sampleBuffer: sample!)
        img.save(as: "\(frameCount)", at: url) { (success) in
            successHandler(success)
        }
    }
    
    func renderFrames(url : URL ,maximumFramesCount : Int, progressHandler : @escaping (Int)->() , completion: @escaping ()->()) {
        let asset = AVAsset(url: url)
        guard let assetTrack = asset.tracks(withMediaType: .video).first else { return }
        
        var assetReader: AVAssetReader?
        do {
            assetReader = try AVAssetReader(asset: asset)
        } catch {
            print(error.localizedDescription)
        }
        
        let assetReaderOutputSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        let assetReaderOutput = AVAssetReaderTrackOutput(track: assetTrack,
                                                         outputSettings: assetReaderOutputSettings)
        assetReaderOutput.alwaysCopiesSampleData = false
        assetReader?.add(assetReaderOutput)
        assetReader?.startReading()
        
        var frameCount = 0
        var sample: CMSampleBuffer? = assetReaderOutput.copyNextSampleBuffer()
        
        guard let videoFrameCount = self.videoFrameCount else {return}
        
        let devision : Int = videoFrameCount/maximumFramesCount
        var frameName = 0
        var shouldRender = true
        if let url = URL(string: savePath) {
            while (sample != nil) {
                if !shouldRender {
                    DialogManager.shared.saveLoactionAgain()
                    return
                }
                if frameCount % devision == 0 {
                    self.saveFrame(sample, frameName, url) { (success) in
                        shouldRender = success
                    }
                    frameName += 1
                }
                frameCount += 1
                progressHandler(frameCount)
                sample = assetReaderOutput.copyNextSampleBuffer()
            }
            completion()
        } else {
            DialogManager.shared.saveLoactionAgain()
        }
    }
    
    func getFramesCount(url : URL) -> Int?{
        let asset = AVAsset(url: url)
        guard let assetTrack = asset.tracks(withMediaType: .video).first else { return nil }
        
        var assetReader: AVAssetReader?
        do {
            assetReader = try AVAssetReader(asset: asset)
        } catch {
            print(error.localizedDescription)
        }
        
        let assetReaderOutputSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        let assetReaderOutput = AVAssetReaderTrackOutput(track: assetTrack,
                                                         outputSettings: assetReaderOutputSettings)
        assetReaderOutput.alwaysCopiesSampleData = false
        assetReader?.add(assetReaderOutput)
        assetReader?.startReading()
        
        var frameCount = 0
        var sample: CMSampleBuffer? = assetReaderOutput.copyNextSampleBuffer()
        while (sample != nil) {
            frameCount += 1
            DispatchQueue.main.async {
                self.videoFramesCountLabel.stringValue = Strings.videoFrameCount(count: frameCount)
            }
            sample = assetReaderOutput.copyNextSampleBuffer()
        }
        return frameCount
    }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> NSImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        // Create an image object from the Quartz image
        let image = NSImage.init(cgImage: quartzImage!, size: NSSize(width: quartzImage!.width, height: quartzImage!.height));
        
        return (image);
    }
}


