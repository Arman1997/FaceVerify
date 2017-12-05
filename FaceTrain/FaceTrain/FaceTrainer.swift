//
//  FaceTrainer.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import LASwift

final class FVPerson {
    private var _faceID: String!
    var faceID: String {
        return _faceID
    }
    
    init(id: String) {
        self._faceID = id
    }
    
}

final class FVRecognitionTrainController {
    private let percenteage: Double = 0.1
    private var facesBitArraysCollection = [TrainFaceBitArray]()
    private var averageFace = Vector()
    private var averageVectors: Matrix!
    private var transposeOfAverageVectors: Matrix!
    private var transposeOfCovarianseMatrix: Matrix!
    private var eigenVectors: Matrix!
    private var eigensMatrixTranspose: Matrix!
    private var porjectionMatrix: Matrix!
    private var personsList = [FVPerson]()
    
    
    func startTrain() {
        makeAverageFace()
        countAverageVectors()
        countCovariance()
        findEigens()
    }
    
    func appendFace(forImage faceImage: UIImage) throws -> FVPerson {
        do {
            let recognitionImageBitsArray =  try FVRecognitionImage(image: faceImage).getBitArray()
            self.facesBitArraysCollection.append(recognitionImageBitsArray)
            let person = FVPerson(id: UUID().uuidString)
            personsList.append(person)
            return person
        } catch (let error) {
            throw error
        }
    }
    
    
    private func makeAverageFace() {
        let faceCollectionCount = facesBitArraysCollection.count
        averageFace = sum(Matrix(facesBitArraysCollection.map({ $0.bitMap })),.Column)
        averageFace = rdivide(averageFace, Double(faceCollectionCount))
    }
    
    private func countAverageVectors() {
        transposeOfAverageVectors = Matrix(facesBitArraysCollection.map({ $0.bitMap - averageFace }))
        averageVectors = transpose(transposeOfAverageVectors)
    }
    
    private func countCovariance() { 
        transposeOfCovarianseMatrix = mtimes(transposeOfAverageVectors, averageVectors)
    }
    
    private func findEigens() {
        let temporaryEigens = eigen(transposeOfCovarianseMatrix)
        let normalCount = 4
        var sortedEigens = temporaryEigens.sorted(by: >)
        let normalEigens = sortedEigens[0..<normalCount]
        let eigensArray = normalEigens.map({ mtimes(averageVectors, $0.vectorMatrix)[col: 0] })
        self.eigensMatrixTranspose = Matrix(eigensArray)
        self.porjectionMatrix = mtimes(self.eigensMatrixTranspose, averageVectors)
    }
    
    func verify(face: FVRecognitionImage) -> FVPerson {
        let faceBitMap = face.getBitArray().bitMap
        var faceMatrix = zeros(faceBitMap.count, 1)
        faceMatrix = insert(faceMatrix, col: faceBitMap - averageFace, at: 0)
        let weightMatrix = mtimes(eigensMatrixTranspose, faceMatrix)
        let weightVector = weightMatrix[col: 0]
        
        //////
    
        var trainFaceVectors = [Vector]()
        for colIndex in 0..<self.porjectionMatrix.cols {
            trainFaceVectors.append(self.porjectionMatrix[col: colIndex])
        }
        
        let dividingVectors = trainFaceVectors.map({ sum(abs($0 - weightVector))})
        let personIndex = mini(dividingVectors)
        print("personindex \(personIndex)")
        return personsList[personIndex]
    }
  
    
}
