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
    }
    
    @IBOutlet weak var personNameTextField: UITextField!
    @IBAction func detect(_ sender: Any) {
      /*  do {
            let detectedimage = try FVRecognitionImage(image: UIImage(named: personNameTextField.text!)!)
            personImageViwe.image = detectedimage.image
            let fvPerson =  FVRecognitionTrainController.shared.verify(face: try FVRecognitionImage(image: UIImage(named: personNameTextField.text!)!))
            let person = self.persons.filter({ $0.id == fvPerson.faceID }).first!
            let name = person.name
            self.faceNameLabel.text = name
        } catch  {
            self.faceNameLabel.text = "not detected"
        }*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       // let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
      /*  let dat1 = Date().millisecondsSince1970
        let images = [
                      "spartak1",
                      "arman1",
                      "arman3",
                      "arman4",
                      "artur1",
                      "rustam1",
                      "Samo",
                      "Hayko",
                      "Armen"
                      ]
        images.forEach({
            do {
            let fvPerson = try FVRecognitionTrainController.shared.appendFace(forImage: UIImage(named: $0)!)
            persons.append(Person(name: $0, id: fvPerson.faceID))
            } catch {
                
            }
        })
        
        FVRecognitionTrainController.shared.startTrain()
        print(Date().millisecondsSince1970 - dat1)*/
        
    }
}
