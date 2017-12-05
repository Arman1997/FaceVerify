//
//  TrainFaceBitArray.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 12/6/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import UIKit
import LASwift

internal struct TrainFaceBitArray {
    var bitArray: Vector
    init(image: UIImage) {
        let rgbaImage = RGBAImage(image: image)
        let rgbaImageBitArray = Array(rgbaImage!.pixels)
        bitArray = rgbaImageBitArray.map({ (Double($0.B) + Double($0.R) + Double($0.G)) / Double(3)})
    }
    
    init(data: Data) throws {
        guard let faceImage = UIImage(data: data) else {
            //TODO
            throw "some error need to be implemented"
        }
        self.init(image: faceImage)
    }
}
