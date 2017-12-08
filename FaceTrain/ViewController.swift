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

final class Person {
    var name: String!
    var id: String!
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    var trainFace: FVRecognitionImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
    }
    var persons = [Person]()
    
    @IBOutlet weak var personImageViwe: UIImageView!
    @IBOutlet weak var faceNameLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vector1 = [1.0,2.0,3.0]
        let vector2 = [0.0,0.0,0.0]
        let vector3 = [0.0,0.0,0.0]
        let matr = Matrix([vector1,vector2,vector3])
        print(sum(matr,.Row))
        let sVec = [2.0,2.0,2.0]
        print(plus(matr, sVec))
    }
    let verifier = FVRecognitionTrainController()
    @IBOutlet weak var personNameTextField: UITextField!
    @IBAction func detect(_ sender: Any) {
        do {
            let detectedimage = try FVRecognitionImage(image: UIImage(named: personNameTextField.text!)!)
            personImageViwe.image = detectedimage.image
            let fvPerson =  verifier.verify(face: try FVRecognitionImage(image: UIImage(named: personNameTextField.text!)!))
            let person = self.persons.filter({ $0.id == fvPerson.faceID }).first!
            let name = person.name
            self.faceNameLabel.text = name
        } catch  {
            self.faceNameLabel.text = "not detected"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       // let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        let dat1 = Date().millisecondsSince1970
        let images = [
            "a1t",
            "a2t",
            "a3t",
            "a4t",
            "a5t",
            "a6t",
            "a7t",
            "a8t",
            "a9t",
            "a10t",
            "a11t",
            "a12t",
            "a13t",
            "a14t",
            "a15t",
            "a16t",
            "a17t",
            "arman1",
            "arman8",
            "arman9",
            "h1t",
            "h2t",
            "h3t",
            "a8t",
                      "spartak1",
                      "artur1",
                      "rustam1",
                      "Samo",
                      "Armen",
                      ]
        images.forEach({
            do {
            let fvPerson = try verifier.appendFace(forImage: UIImage(named: $0)!)
            persons.append(Person(name: $0, id: fvPerson.faceID))
            } catch {
                
            }
        })
        verifier.startTrain()
        print(Date().millisecondsSince1970 - dat1)
        
    }
}
