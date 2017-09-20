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
import LASwift

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
        FaceTrainer.shared.verify(face: TrainFaceImage(image: self.personImageView.image!))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        personImageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
 

    @IBAction func cameraButtonAction(_ sender: Any) {
        let dat1 = Date().millisecondsSince1970
        let images = ["arman1","arman2","arman3","arman4","arman5",
                      "bob1","bob2","bob3","bob4","bob5",
                      "dicap1","dicap2","dicap3","dicap4","dicap5",
                      "jz1","jz2","jz3","jz4","jz5",
                      
                      ]
        var faceImages = [TrainFaceImage]()
        images.forEach({ faceImages.append(TrainFaceImage.init(image: UIImage(named: $0)!))})
        faceImages.forEach({ FaceTrainer.shared.appendFace(forImage: $0) })
        FaceTrainer.shared.startTrain()
        print(Date().millisecondsSince1970 - dat1)
    }
    

    
}

extension Date {
    var millisecondsSince1970:CLong {
        return CLong((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
}
