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

        // Drawing code here.
        
        let fileURL = Bundle.main.url(forResource: "people", withExtension: "jpg")
        // 2
        let beginImage = CIImage(contentsOf: fileURL!)

        // 3
        // Try out various filters
        
        // Adjusts saturation, brightness, and contrast values.
        // To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation.
        let filter = CIFilter(name: "CIGloom")
        filter!.setValue(beginImage, forKey: kCIInputImageKey)
        filter!.setValue(10.0, forKey: "inputRadius")
        filter!.setValue(1.5,  forKey: "inputIntensity")

        // 4 Apply filter and
        // convert CIImage to NSImage
        let rep: NSCIImageRep = NSCIImageRep(ciImage: filter!.outputImage!)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        // 1) Just draw it
        // nsImage.drawAtPoint(NSZeroPoint, fromRect: NSZeroRect, operation:.CompositeSourceOver, fraction: 1)
        // 2) Or stretch image to fill view
        nsImage.draw(in: self.bounds, from:NSZeroRect ,operation:.sourceOver, fraction:1)

    }
 
}
