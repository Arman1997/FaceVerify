//
//  FaceTrainer.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import Accelerate

final class FaceTrainer {
    static let shared = FaceTrainer()
    private var facesBitArraysCollection = [TrainFaceBitArray]()
    private var averageFace = [Float].init(repeating: 0, count: 10000)
    private var averageVectors = [[Float]]()
    private init() {
        
    }
    
    func appendFace(forImage faceImage: TrainFaceImage) {
        self.facesBitArraysCollection.append(faceImage.getBitArray())
    }
    
    func startTrain() {
        makeAverageFace()
        countAverageVectors()
    }
    
    private func makeAverageFace() {
        let faceCollectionCount = facesBitArraysCollection.count
        facesBitArraysCollection.forEach({ averageFace += $0.bitMap })
        averageFace = averageFace.map({ $0 / Float(faceCollectionCount) })
    }
    
    private func countAverageVectors() {
        facesBitArraysCollection.forEach({ averageVectors.append( $0.bitMap - averageFace )})
    }
 
    
}

func -(left: [Int], right: [Float]) -> [Float] {
    var sum = [Float]()
    var leftIterator = left.makeIterator()
    var rightIterator = right.makeIterator()
    
    while let leftValue = leftIterator.next(), let rightValue = rightIterator.next() {
        sum.append(Float(leftValue) - rightValue)
    }
    
    return sum
}

func +=(left: inout [Float], right: [Int]) {
    var sum = [Float]()
    var leftIterator = left.makeIterator()
    var rightIterator = right.makeIterator()
    
    while let leftValue = leftIterator.next(), let rightValue = rightIterator.next() {
        sum.append(leftValue + Float(rightValue))
    }
    left = sum
}
