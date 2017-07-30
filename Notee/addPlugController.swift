//
//  addPlugController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase
import UITextField_Shake

class addPlugController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var delegate:AddingPlugDelegate!
    var discipline : String?
    var theme : Theme?
    var urlSheet : URL?
    var member : Member?
    
    lazy var pickerViewDiscipline : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    
    var sheet : UIImage? {
        didSet {
            self.sheetImage.image = sheet
        }
    }
    
    let activityIndicor : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
    }()
    
    lazy var sheetImage : UIImageView = {
        let image = UIImageView()
        image.image = self.sheet
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor(r: 80, g: 90, b: 98).cgColor
        image.layer.borderWidth = 2
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    let buttonPhoto : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
     let pickerImage = UIImagePickerController()
    
    /*--------------------------------------- CONSTANTS ---------------------------------------------*/
    
    let titleTextField = TextFieldAdding(placeholderText: "Titre")
    let descriptionTextField = TextFieldAdding(placeholderText: "Description")
    let themeTextField  = TextFieldAdding(placeholderText: "Theme")
    let disciplineTextField  = TextFieldAdding(placeholderText: "Matière")
    
    let buttonValidate = ButtonInMenus(text: "AJOUTER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = "Ajouter"
        self.view.addSubview(titleTextField)
        self.view.addSubview(buttonValidate)
        loadDiscipline()
        pickerImage.delegate = self
        disciplineTextField.textField.inputView = pickerViewDiscipline
        disciplineTextField.text = discipline
        themeTextField.text = theme?.name
        hideKeyboardWhenTappedAround()
        setupTextField()
        loadUser()
        setupButtonValidate()
        buttonPhoto.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        sheetImage.isUserInteractionEnabled = true
        sheetImage.addGestureRecognizer(tapGestureRecognizer)
    }

    func takePhoto() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "L'appareil n'a pas de camera", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "D'accord", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            let pickerPhoto = UIImagePickerController()
            pickerPhoto.delegate = self
            pickerPhoto.sourceType = UIImagePickerControllerSourceType.camera
            pickerPhoto.cameraCaptureMode = .photo
            pickerPhoto.modalPresentationStyle = .fullScreen
            present(pickerPhoto,animated: true,completion: nil)
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        pickerImage.sourceType = .photoLibrary
        present(pickerImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.sheet = chosenImage
        }
        if let chosenImagePath = info[UIImagePickerControllerReferenceURL] as? URL {
            self.urlSheet = chosenImagePath
            print("chosenPath : \(chosenImagePath)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    var newPlug : Plug?
    func handleCreate() {
        guard let title = titleTextField.textField.text ,let descriptionData =  self.descriptionTextField.textField.text, let photo = sheet else {
            return
        }
        if title.characters.count > 0 && descriptionData.characters.count > 0 {
            newPlug = Plug(title: title, description: descriptionData,photo: photo, starsCount : 0)
            newPlug?.member = self.member
            self.activityIndicor.startAnimating()
            self.titleTextField.textField.isEnabled = false
            self.descriptionTextField.textField.isEnabled = false
            self.themeTextField.textField.isEnabled = false
            self.disciplineTextField.textField.isEnabled = false
            self.buttonValidate.isEnabled = false
            addNewSheet()
        } else {
            if (title.characters.count == 0){
                titleTextField.textField.shake()
            }
            if (descriptionData.characters.count == 0){
                descriptionTextField.textField.shake()
            }
        }
    }
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("members/\(uid)")
        ref.observeSingleEvent(of: .value ,with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {return}
            guard let pseudo = values["pseudo"] as? String else {return}
            self.member = Member(id: uid, pseudo: pseudo)
        })
    }
    
    func addNewSheet() {
        guard let plug = newPlug, let memberPseudo = plug.member?.pseudo , let photo = self.sheet, let disciplineName = self.disciplineTextField.textField.text else {
            return
        }
        
        let ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let storageRef = Storage.storage().reference()
        
        let refStorage = storageRef.child("sheets").child(key)
        
        guard let uploadData = UIImageJPEGRepresentation(photo, 0.1) else {
            return
        }
        
        refStorage.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            }
            let downloadURL = metadata!.downloadURL()
            guard let idOfTheme = self.theme?.id, let uid = Auth.auth().currentUser?.uid, let theme = self.themeTextField.text else {
                return
            }
            
            let newPlugValues = ["title" : plug.title, "theme" : theme, "discipline" : disciplineName ,"memberUID": uid, "description" : plug.description, "urlDownload" : downloadURL?.absoluteString,"starsCount" : "\(0)", "date" : "\(NSDate().timeIntervalSince1970)", "pseudo" : memberPseudo]
            
            var childUpdates = ["/sheets/\(key)": newPlugValues,
                                "/theme-sheets/\(idOfTheme)/\(key)/": "true"] as [String : Any]
            
            ref.updateChildValues(childUpdates, withCompletionBlock: { (error, dataReference) in
                childUpdates = ["/sheets/\(key)/members/\(uid)": true] as [String : Any]
                ref.updateChildValues(childUpdates)
            })
            
            self.newPlug?.id = key
            self.newPlug?.urlImage = downloadURL?.absoluteString
            self.delegate.sendPlug(plug: self.newPlug!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var disciplineAvailables : [String] = []
    func loadDiscipline()  {
        let ref = Database.database().reference().child("discipline")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {
                return
            }
            for value in values {
                if let key = value.key as? String {
                    self.disciplineAvailables.append(key)
                }
            }
            self.pickerViewDiscipline.reloadAllComponents()
        }) { (error) in
            print(error.localizedDescription)
        }
    }


    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return disciplineAvailables.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return disciplineAvailables[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.disciplineTextField.text = disciplineAvailables[row]
    }

    
    func setupButtonValidate() {
        buttonValidate.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        buttonValidate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonValidate.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        buttonValidate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonValidate.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        
        self.view.addSubview(activityIndicor)
        
        activityIndicor.centerYAnchor.constraint(equalTo: self.buttonValidate.centerYAnchor).isActive = true
        activityIndicor.leftAnchor.constraint(equalTo: self.buttonValidate.leftAnchor, constant: 20).isActive = true
        activityIndicor.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicor.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupTextField() {
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        descriptionTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(disciplineTextField)
        disciplineTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 30).isActive = true
        disciplineTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        disciplineTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        disciplineTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(themeTextField)
        themeTextField.topAnchor.constraint(equalTo: disciplineTextField.bottomAnchor, constant: 30).isActive = true
        themeTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        themeTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        themeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(sheetImage)
        sheetImage.topAnchor.constraint(equalTo: themeTextField.bottomAnchor, constant: 30).isActive = true
        sheetImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -60).isActive = true
        sheetImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sheetImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(buttonPhoto)
        buttonPhoto.centerYAnchor.constraint(equalTo: sheetImage.centerYAnchor).isActive = true
        buttonPhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 60).isActive = true
        buttonPhoto.widthAnchor.constraint(equalToConstant: 50).isActive = true
        buttonPhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
}
