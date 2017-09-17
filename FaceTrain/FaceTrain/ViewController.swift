//
//  ViewController.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//


import UIKit
import CoreFoundation
import  Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var imageToRecognize: FaceVerifyImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .front
        imagePicker.cameraCaptureMode = .photo
        imagePicker.delegate = self
        
    }
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageToRecognize = FaceVerifyImage(image: image)
        personImageView.image = imageToRecognize.getVerifyImage()
        print(imageToRecognize.getBitArray().bitMap)
        self.imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        self.present(imagePicker, animated: false)
    }
    
}
