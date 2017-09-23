//
//  UIImageExtensions.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/23/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import UIKit

internal extension UIImage {
    func resizedForRecognition() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
        self.draw(in: CGRect(x: 0, y: 0, width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func detectFace() -> UIImage? {
        let personciImage = CIImage(cgImage: self.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            var faceViewBounds = face.bounds.applying(transform)
            let viewSize = CGSize(width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant)
            let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            let faceViewRect = face.bounds.applying(transform)
            let scaleOffset: CGFloat = 10.0
            let scaledFaceViewRect = CGRect(x: faceViewRect.origin.x - (scaleOffset / 2)  , y: faceViewRect.origin.y - scaleOffset, width: faceViewRect.size.width + scaleOffset, height: faceViewRect.size.height + scaleOffset)
            
            let faceImage = cutFace(image: self, rect: scaledFaceViewRect)
            var rotatedFaceImage = faceImage
            if face.hasLeftEyePosition && face.hasRightEyePosition {
                rotatedFaceImage = imageRotatedByDegrees(oldImage: faceImage, deg: CGFloat(getRotationAngle(firstPoint: face.leftEyePosition, secondPoint: face.rightEyePosition)))
            }
            let processedImage = rotatedFaceImage.resizedForRecognition()
            return processedImage
        }
        return nil
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

internal let TrainFaceImageWidthConstant: CGFloat = 100
internal let TrainFaceImageHeightConstant: CGFloat = 100

fileprivate func cutFace(image: UIImage,rect: CGRect) -> UIImage {
    let cropImage = image.cgImage!
    let cropedImage = cropImage.cropping(to: rect)
    return UIImage(cgImage: cropedImage!)
}


fileprivate func getRotationAngle(firstPoint: CGPoint, secondPoint: CGPoint) -> Double {
    let h = firstPoint.y - secondPoint.y
    let l = getDistance(ofPoint: firstPoint, fromPoint: secondPoint)
    let  sin = h / l
    return  -asin(Double(sin)) * 180 / Double.pi
}

fileprivate func getDistance(ofPoint firstPoint: CGPoint, fromPoint secondPoint: CGPoint) -> CGFloat {
    return sqrt(pow((firstPoint.x - secondPoint.x),2) + pow((firstPoint.y - secondPoint.y),2))
}



fileprivate func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
    let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
    let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    rotatedViewBox.transform = t
    let rotatedSize: CGSize = rotatedViewBox.frame.size
    UIGraphicsBeginImageContext(rotatedSize)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

