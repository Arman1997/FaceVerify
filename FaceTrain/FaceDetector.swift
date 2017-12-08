//
//  FaceDetector.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 12/6/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import Vision
import UIKit

internal final class FVFaceDetector {
    
    func detectFace(inImageWithData data: Data) throws -> UIImage? {
        guard let image = UIImage(data: data) else {
            throw "error: invalid data"
        }
        
        let detectedFaceImage = try self.detectFace(inImage: image)
        return detectedFaceImage
    }
    
    func detectFace(inImage image: UIImage) throws -> UIImage? {
        var imageForFaceDetection = image
        if imageForFaceDetection.imageOrientation != UIImageOrientation.up {
            imageForFaceDetection = imageForFaceDetection.normalaized()
        }
        
        let personciImage = CIImage(cgImage: imageForFaceDetection.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        
        let faces = faceDetector?.features(in: personciImage)
        
        guard let detectedFaces = faces, !detectedFaces.isEmpty else {
            return nil
        }
        
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        if detectedFaces.count > 1 {
            throw "more then one face"
        }
        
        let face = detectedFaces.first as! CIFaceFeature
        
        guard face.hasLeftEyePosition && face.hasRightEyePosition else {
            return nil
        }
        
        let rotationAngle = CGFloat(getRotationAngle(firstPoint: face.leftEyePosition, secondPoint: face.rightEyePosition))
        let faceViewRect = face.bounds.applying(transform)
        let cuttenFaceImage = cutFace(image: imageForFaceDetection, rect: computeScaleFaceRect(fromRect: faceViewRect, rotationAngle: Double(rotationAngle)))
        let rotatedFaceImage = cuttenFaceImage.rotated(byDegrees: rotationAngle)
            
        let processedImage = rotatedFaceImage.resizedForRecognition()
        return processedImage

    }
    
}
