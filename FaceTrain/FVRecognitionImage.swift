//
//  FVRecognitionImage.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 12/6/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import UIKit

internal class FVRecognitionImage {
    private var bitArray: TrainFaceBitArray!
    var image: UIImage
    init(image: UIImage) throws {
        let faceDetector = FVFaceDetector()
        guard let detectedFaceImage = try faceDetector.detectFace(inImage: image) else {
            throw FVError.noFaceDetected
        }
        self.bitArray = TrainFaceBitArray(image: detectedFaceImage.grayScaleImage())
        self.image = detectedFaceImage.grayScaleImage()
    }
    
    convenience init(data: Data) throws {
        guard let image = UIImage(data: data) else {
            throw "error: invalid parameter"
        }
        try self.init(image: image)
    }
    
    internal func getBitArray() -> TrainFaceBitArray {
        return self.bitArray
    }
}
