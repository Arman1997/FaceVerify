//
//  ViewController.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//


import UIKit
import Foundation

public struct FaceVerifyBitArray {
    var bitMap: [Int]
    init(image: UIImage) {
        let rgbaImage = RGBAImage(image: image)
        let rgbaImageBitArray = Array(rgbaImage!.pixels)
        bitMap = rgbaImageBitArray.map({ (Int($0.B) + Int ($0.R) + Int($0.G)) / 3})
    }
}

public class FaceVerifyImage {
    private var verifyImage: UIImage!
    private var bitArray: FaceVerifyBitArray!
    
    init(image: UIImage) {
        let imageToChange = resize(image: image)
        self.verifyImage = convertToGrayScale(image: imageToChange)
        self.bitArray = FaceVerifyBitArray(image: self.verifyImage)
    }
    
    private func convertToGrayScale(image: UIImage) -> UIImage {
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
    
    func getVerifyImage() -> UIImage {
        return verifyImage
    }
    
    func getBitArray() -> FaceVerifyBitArray {
        return bitArray
    }
    
}

fileprivate let FaceVerifyImageWidthConstant: CGFloat = 100
fileprivate let FaceVerifyImageHeightConstant: CGFloat = 100

fileprivate func resize(image: UIImage) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: FaceVerifyImageWidthConstant, height: FaceVerifyImageHeightConstant))
    image.draw(in: CGRect(x: 0, y: 0, width: FaceVerifyImageWidthConstant, height: FaceVerifyImageHeightConstant))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

public struct Pixel {
    
    public var value: UInt32
    
    public var R: UInt8 {
        get { return UInt8(value & 0xFF); }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    
    public var G: UInt8 {
        get { return UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    
    public var B: UInt8 {
        get { return UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    
    public var A: UInt8 {
        get { return UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }
}

public struct RGBAImage {
    public var pixels: UnsafeMutableBufferPointer<Pixel>
    public var width: Int
    public var height: Int
    
    public init?(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        
        let bytesPerRow = width * 4
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        imageContext.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
        
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    public func toUIImage() -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        let bytesPerRow = width * 4
        
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, releaseCallback: nil, releaseInfo: nil) else {
            return nil
        }
        
        guard let cgImage = imageContext.makeImage() else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
}
