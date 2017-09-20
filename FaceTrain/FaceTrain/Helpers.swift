//
//  Helpers.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/19/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//

import Foundation
import Accelerate
import LASwift

func eigen(_ A: Matrix) -> [Eigen] {
    var matrix = [__CLPK_doublereal]()
    for iIndex in 0..<A.rows {
        for jIndex in 0..<A.cols {
            matrix.append(A[iIndex,jIndex])
        }
    }
    
    var N = __CLPK_integer(sqrt(Double(matrix.count)))
    var workspaceQuery: Double = 0.0
    var error : __CLPK_integer = 0
    var lwork = __CLPK_integer(-1)
    // Real parts of eigenvalues
    var wr = [Double](repeating: 0, count: Int(N))////////
    // Imaginary parts of eigenvalues
    var wi = [Double](repeating: 0, count: Int(N))
    // Left eigenvectors
    var vl = [__CLPK_doublereal](repeating: 0, count: Int(N*N))///////
    // Right eigenvectors
    var vr = [__CLPK_doublereal](repeating: 0, count: Int(N*N))
    
    dgeev_(UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &matrix, &N, &wr, &wi, &vl, &N, &vr, &N, &workspaceQuery, &lwork, &error)
    
    // prints "102.0"
    print("\(workspaceQuery)")
    
    // size workspace per the results of the query:
    var workspace = [Double](repeating: 0.0, count: Int(workspaceQuery))
    lwork = __CLPK_integer(workspaceQuery)
    
    dgeev_(UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &matrix, &N, &wr, &wi, &vl, &N, &vr, &N, &workspace, &lwork, &error)
    
    var eigenValues = Vector(wr)
    var eigens = [Eigen]()
    for i in stride(from: wr.count, to: vl.count + 1, by: wr.count).reversed() {
        let eigen = Eigen(value: eigenValues.popLast()!, vector: Vector(vl[i-wr.count..<i]))
        eigens.append(eigen)
    }
    return eigens
}


struct Eigen {
    var value: Double!
    var vectorMatrix: Matrix!
    var vector: Vector
    init(value: Double, vector: Vector) {
        self.value = value
        self.vector = vector
        self.vectorMatrix = zeros(vector.count, 1)
        self.vectorMatrix = insert(self.vectorMatrix, col: vector, at: 0)
    }
    
    
    
}

func <(_ left: Eigen, right: Eigen) -> Bool {
    return left.value < right.value
}

func >(_ left: Eigen, right: Eigen) -> Bool {
    return left.value > right.value
}











