//
//  MyView.swift
//  FaceDectect
//
//  Created by Friedrich HAEUPL on 23.01.17.
//  Copyright © 2017 Friedrich HAEUPL. All rights reserved.
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
        
        let fileURL = Bundle.main.url(forResource: "people", withExtension: "jpg")
        // 2
        let ciImage = CIImage(contentsOf: fileURL!)
        NSLog("ciImage extent \(ciImage!.extent)")

        // 3
        // https://www.hackingwithswift.com/example-code/media/cidetectortypeface-how-to-detect-faces-in-a-uiimage
/*
        // Adjusts saturation, brightness, and contrast values.
        // To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation.
        let filter = CIFilter(name: "CIGloom")
        filter!.setValue(beginImage, forKey: kCIInputImageKey)
        filter!.setValue(10.0, forKey: "inputRadius")
        filter!.setValue(1.5,  forKey: "inputIntensity")
*/
        // 4 Render Image
        // convert CIImage to NSImage
        let rep: NSCIImageRep = NSCIImageRep(ciImage: ciImage!)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        // 1) Just draw it
        // nsImage.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation:.CompositeSourceOver, fraction: 1)
        // 2) Or stretch image to fill view
        nsImage.draw(in: self.bounds, from:NSZeroRect ,operation:.sourceOver, fraction:1)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        
        let faces = faceDetector.features(in: ciImage!)
        
        for face in faces as! [CIFaceFeature] {
        //if let face = faces.first as? CIFaceFeature {
            NSLog("Found face at \(face.bounds) of \(faces.count) Faces")
            
            
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
            let rect = NSRect(x: (face.bounds.origin.x),
                              y: (face.bounds.origin.y),
                              width: (face.bounds.size.width),
                              height: (face.bounds.size.height))
            
            path.appendRect(rect)

            let mrect = NSRect(x: mpos.x - 10 ,
                              y: mpos.y - 5 ,
                              width: 20,
                              height: 10)
            
            path.appendRect(mrect)

            let erect1 = NSRect(x: epos1.x - 10 ,
                               y: epos1.y - 10 ,
                               width: 20,
                               height: 20)
            
            path.appendRect(erect1)
            
            let erect2 = NSRect(x: epos2.x - 10 ,
                                y: epos2.y - 10 ,
                                width: 20,
                                height: 20)
            
            path.appendRect(erect2)

            //
            path.stroke()
            
        }        /* */
        

    }
 
}
