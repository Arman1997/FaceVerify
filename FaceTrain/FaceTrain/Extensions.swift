//
//  Extensions.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 12/6/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import UIKit
import LASwift

internal extension UIImage {
    func resizedForRecognition() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
        self.draw(in: CGRect(x: 0, y: 0, width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func normalaized() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.height))
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func rotated(byDegrees degrees: CGFloat) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func grayScaleImage() -> UIImage {
        let image = self
        let imageRect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let imageReference = image.cgImage
        context!.draw(imageReference!, in: imageRect)
        let newImage = UIImage(cgImage: (context?.makeImage()!)!)
        return newImage
    }
}

internal extension Date {
    var millisecondsSince1970:CLong {
        return CLong((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
}

internal extension Array where Element == Double {
    func normalized() -> [Double] {
        let sumOfArray = sqrt(sum(self.map({ pow($0,2)})))
        return self.map({ $0 / sumOfArray })
    }
}

