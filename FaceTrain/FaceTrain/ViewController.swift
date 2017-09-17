//
//  ViewController.swift
//  FaceTrain
//
//  Created by Arman Galstyan on 9/17/17.
//  Copyright © 2017 Arman Galstyan. All rights reserved.
//


import UIKit
import  Foundation
import CoreImage


class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var faceImageView: UIImageView!
    var trainFace: TrainFaceImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
    }
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func detect(_ sender: Any) {
        trainFace = TrainFaceImage(image: personImageView.image!)
        self.faceImageView.image = trainFace.getTrainImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        personImageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
 

    @IBAction func cameraButtonAction(_ sender: Any) {
        self.present(imagePicker, animated: false)
    }
    
}
