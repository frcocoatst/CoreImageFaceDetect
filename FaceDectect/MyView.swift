//
//  MyView.swift
//  FaceDectect
//
//  Created by Friedrich HAEUPL on 23.01.17.
//  Copyright © 2017 Friedrich HAEUPL. All rights reserved.
//
//  https://www.hackingwithswift.com/example-code/media/cidetectortypeface-how-to-detect-faces-in-a-uiimage
//  https://www.appcoda.com/face-detection-core-image/
//  https://panic.com/blog/fun-with-face-recognition/
//

import Cocoa

class MyView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSLog("dirtyRect = \(dirtyRect)")

        // Drawing code here.
        var mpos: CGPoint = CGPoint()
        var epos1: CGPoint = CGPoint()
        var epos2: CGPoint = CGPoint()
        
        // avoid optional unwrapping later :
        // 1
        guard let fileURL = Bundle.main.url(forResource: "people", withExtension: "jpg")
        else
        {
            NSLog("ciImage doesn't exist")
            return
        }
        // 2
        guard let ciImage = CIImage(contentsOf: fileURL)
        else
        {
            NSLog("ciImage not loaded")
            return
        }

        // 3    get size of the image
        let ciImageSize = ciImage.extent.size
        NSLog("ciImage extent \(ciImage.extent)")

        // 4    convert CIImage to NSImage
        let rep: NSCIImageRep = NSCIImageRep(ciImage: ciImage)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        // 1) Just draw it
        // nsImage.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation:.CompositeSourceOver, fraction: 1)
        // 2) Or stretch image to fill view
        nsImage.draw(in: self.bounds, from:NSZeroRect ,operation:.sourceOver, fraction:1)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        
        let faces = faceDetector.features(in: ciImage)
        
        
        for face in faces as! [CIFaceFeature] {
        //if let face = faces.first as? CIFaceFeature {
            NSLog("---------")
            NSLog("Found face at \(face.bounds) of \(faces.count) Faces")

            // 
            var faceViewBounds = face.bounds
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = dirtyRect.size
            //  if scales in both directions equally :
            //  let scale = min(viewSize.width / (ciImageSize?.width)!,
            //                viewSize.height / (ciImageSize?.height)!)
            let scale_w = viewSize.width / (ciImageSize.width)
            let scale_h = viewSize.height / (ciImageSize.height)
            let offsetX = (viewSize.width - (ciImageSize.width) * scale_w) / 2.0
            let offsetY = (viewSize.height - (ciImageSize.height) * scale_h) / 2.0
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale_w, y: scale_h))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            NSLog("faceViewBounds is \(faceViewBounds)")
            
            if face.hasLeftEyePosition {
                epos1 = face.leftEyePosition
                NSLog("Found left eye at \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                epos2 = face.rightEyePosition
                NSLog("Found right eye at \(face.rightEyePosition)")
            }
            
            if face.hasMouthPosition {
                mpos = face.mouthPosition
                NSLog("Found mouth at \(face.mouthPosition)")
            }
            
            if face.hasSmile {
                NSLog("face is smiling");
            }
            
            // draw rectangle https://www.appcoda.com/face-detection-core-image/
            //
            NSColor.red.set()
            let path:NSBezierPath = NSBezierPath()            
            path.appendRect(faceViewBounds)

            var mrect = NSRect(x: mpos.x - 10 ,
                              y: mpos.y - 5 ,
                              width: 20,
                              height: 10)
            
            mrect = mrect.applying(CGAffineTransform(scaleX: scale_w, y: scale_h))
            mrect.origin.x += offsetX
            mrect.origin.y += offsetY

            
            path.appendRect(mrect)

            var erect1 = NSRect(x: epos1.x - 10 ,
                               y: epos1.y - 10 ,
                               width: 20,
                               height: 20)
            
            erect1 = erect1.applying(CGAffineTransform(scaleX: scale_w, y: scale_h))
            erect1.origin.x += offsetX
            erect1.origin.y += offsetY
            
            path.appendRect(erect1)
            
            var erect2 = NSRect(x: epos2.x - 10 ,
                                y: epos2.y - 10 ,
                                width: 20,
                                height: 20)
            
            erect2 = erect2.applying(CGAffineTransform(scaleX: scale_w, y: scale_h))
            erect2.origin.x += offsetX
            erect2.origin.y += offsetY
            
            path.appendRect(erect2)

            //
            path.stroke()
            
        }        /* */
        

    }
 
}
