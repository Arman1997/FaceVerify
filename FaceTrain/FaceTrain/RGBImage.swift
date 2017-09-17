//
//  ViewController.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//


import UIKit
import Foundation

public struct TrainFaceBitArray {
    var bitMap: [Int]
    init(image: UIImage) {
        let rgbaImage = RGBAImage(image: image)
        let rgbaImageBitArray = Array(rgbaImage!.pixels)
        bitMap = rgbaImageBitArray.map({ (Int($0.B) + Int ($0.R) + Int($0.G)) / 3})
    }
}

public class TrainFaceImage {
    private var trainImage: UIImage!
    private var bitArray: TrainFaceBitArray!
    
    init(image: UIImage) {
        let imageToChange = resize(image: image)
        let detectedFace = detectFace(inImage: imageToChange)
        self.trainImage = convertToGrayScale(image: detectedFace!)
        self.bitArray = TrainFaceBitArray(image: self.trainImage)
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
    
    func getTrainImage() -> UIImage {
        return trainImage
    }
    
    func getBitArray() -> TrainFaceBitArray {
        return bitArray
    }
    
   fileprivate func detectFace(inImage image: UIImage) -> UIImage? {
        let personciImage = CIImage(cgImage: image.cgImage!)
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
            
            let faceImage = cutFace(image: image, rect: scaledFaceViewRect)
            var rotatedFaceImage = faceImage
            if face.hasLeftEyePosition && face.hasRightEyePosition {
                rotatedFaceImage = imageRotatedByDegrees(oldImage: faceImage, deg: CGFloat(getEyesRotationAngle(leftEyePosition: face.leftEyePosition, rightEyePosition: face.rightEyePosition)))
            }
            let processedImage = resize(image: rotatedFaceImage)
            return processedImage
        }
        return nil
    }
    
    fileprivate func cutFace(image: UIImage,rect: CGRect) -> UIImage {
        let cropImage = image.cgImage!
        let cropedImage = cropImage.cropping(to: rect)
        return UIImage(cgImage: cropedImage!)
    }
    
    
    fileprivate func getEyesRotationAngle(leftEyePosition: CGPoint, rightEyePosition: CGPoint) -> Double {
        let h = leftEyePosition.y - rightEyePosition.y
        let l = getDistance(ofPoint: leftEyePosition, fromPoint: rightEyePosition)
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
    
}

fileprivate let TrainFaceImageWidthConstant: CGFloat = 100
fileprivate let TrainFaceImageHeightConstant: CGFloat = 100

fileprivate func resize(image: UIImage) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
    image.draw(in: CGRect(x: 0, y: 0, width: TrainFaceImageWidthConstant, height: TrainFaceImageHeightConstant))
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
