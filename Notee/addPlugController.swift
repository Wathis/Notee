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

class addPlugController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, AddingDisciplineDelegate , UINavigationControllerDelegate, SendTagsDelegate {
    
    var delegate:AddingPlugDelegate!
    var discipline : String? {
        didSet {
            self.disciplineTextField.textField.text = discipline
        }
    }
    
    var foldersAlreadyCreated = true
    
    var theme : Theme?
    var urlSheet : URL?
    var member : Member?
    var tagsList : [String] = [] {
        didSet {
            var content = ""
            for tag in tagsList {
                content += "\(tag), "
            }
            self.tagsTextField.textField.text = content
        }
    }
    
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
    let disciplineTextField  = TextFieldAdding(placeholderText: "Matière")
    let themeSheetTextField  = TextFieldAdding(placeholderText: "Thème")
    let tagsTextField = TextFieldAdding(placeholderText: "Tags")
    
    let buttonValidate = ButtonInMenus(text: "PARTAGER", backgroundColor: UIColor(r: 152, g: 152, b: 152))
    
/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    init(foldersAlreadyCreated : Bool) {
        super.init(nibName: nil, bundle: nil)
        self.foldersAlreadyCreated = foldersAlreadyCreated
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.title = "Ajouter"
        self.view.addSubview(titleTextField)
        self.view.addSubview(buttonValidate)
        pickerImage.delegate = self
        disciplineTextField.text = discipline
        themeSheetTextField.text = theme?.name
        hideKeyboardWhenTappedAround()
        setupTextField()
        loadUser()
        tagsTextField.textField.delegate = self
        disciplineTextField.textField.delegate = self
        themeSheetTextField.textField.delegate = self
        setupButtonValidate()
        buttonPhoto.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        sheetImage.isUserInteractionEnabled = true
        sheetImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.disciplineTextField.textField {
            let controller = addDisciplineController()
            controller.delegate = self
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: {
                controller.buttonValidate.setTitle("CHOISIR", for: .normal)
                controller.textField.becomeFirstResponder()
            })
        }
        if textField == self.tagsTextField.textField {
            handleTags()
        }
    }
    
    func sendString(disciplineName: String) {
        self.discipline = disciplineName
    }
    
    func sendTags(tags: [String]) {
        self.tagsList = tags
    }
    
    func handleTags() {
        let controller  = TagsController(collectionViewLayout: UICollectionViewLayout())
        controller.keywords = self.tagsList
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
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
        guard let discipline = self.disciplineTextField.textField.text, let theme = self.themeSheetTextField.textField.text,let title = titleTextField.textField.text ,let descriptionData =  self.descriptionTextField.textField.text, let photo = sheet else {
            if sheet == nil {
                pickerImage.sourceType = .photoLibrary
                present(pickerImage, animated: true, completion: nil)
            }
            return
        }
        if title.characters.count > 0 && descriptionData.characters.count > 0 && tagsList.count > 0 && discipline.characters.count > 0 && theme.characters.count > 0 {
            newPlug = Plug(title: title, description: descriptionData,photo: photo, starsCount : 0)
            newPlug?.member = self.member
            self.activityIndicor.startAnimating()
            self.titleTextField.textField.isEnabled = false
            self.descriptionTextField.textField.isEnabled = false
            self.tagsTextField.textField.isEnabled = false
            self.disciplineTextField.textField.isEnabled = false
            self.buttonValidate.isEnabled = false
            addNewSheet()
        } else {
            if tagsList.count == 0 {
                tagsTextField.textField.shake()
            }
            if (title.characters.count == 0){
                titleTextField.textField.shake()
            }
            if (descriptionData.characters.count == 0){
                descriptionTextField.textField.shake()
            }
            if (discipline.characters.count == 0) {
                disciplineTextField.textField.shake()
            }
            if (theme.characters.count == 0) {
                themeSheetTextField.textField.shake()
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
    
    func addNewTheme(themeName: String) -> String? {
        
        guard let uid = Auth.auth().currentUser?.uid, let disciplineData = self.discipline else {
            return nil
        }
        
        let ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let value = [themeName : true]
        
        let childUpdates = ["/themes/\(key)": value,
                            "/members-themes/\(uid)/\(disciplineData)/\(key)/": value]
        
        ref.updateChildValues(childUpdates)
        return key
    }
    
    func addNewDiscipline(disciplineName: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref  = Database.database().reference().child("members-discipline").child(uid)
        let value = [disciplineName : true]
        ref.updateChildValues(value) { (error, refDatabase) in
            if error != nil {
                print(error!)
                return
            }
        }
    }
    
    func addNewSheet() {
        guard let plug = newPlug, let memberPseudo = plug.member?.pseudo , let photo = self.sheet else {
            return
        }
        
        var tagsDictinary : [String : Bool] = [:]
        for tag in self.tagsList {
            tagsDictinary[tag.lowercased()] = true
        }
        
        let ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        let storageRef = Storage.storage().reference()
        
        let refStorage = storageRef.child("sheets").child(key)
        guard let themeName = self.themeSheetTextField.textField.text ,let disciplineName = self.disciplineTextField.textField.text  else {return}
        if !foldersAlreadyCreated ||  self.theme?.name != themeName {
            self.theme = Theme(name: themeName, id: self.addNewTheme(themeName: themeName))
        }
        if !foldersAlreadyCreated || self.discipline != disciplineName  {
            addNewDiscipline(disciplineName: disciplineName)
            self.discipline = disciplineName
        }
        guard let uploadData = UIImageJPEGRepresentation(photo, 0.1) else {
            return
        }
        
        refStorage.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            }
            let downloadURL = metadata!.downloadURL()
            guard let idOfTheme = self.theme?.id, let uid = Auth.auth().currentUser?.uid, let theme = self.theme?.name else {
                return
            }
            
            let newPlugValues = ["title" : plug.title, "theme" : theme, "discipline" : disciplineName ,"memberUID": uid, "description" : plug.description, "urlDownload" : downloadURL?.absoluteString as Any,"starsCount" : 0, "date" : NSDate().timeIntervalSince1970, "pseudo" : memberPseudo] as [String : Any]
            
            var childUpdates = ["/sheets/\(key)": newPlugValues,
                                "/theme-sheets/\(idOfTheme)/\(key)/": "true"] as [String : Any]
            
            
            
            ref.updateChildValues(childUpdates, withCompletionBlock: { (error, dataReference) in
                childUpdates = ["/sheets/\(key)/members/\(uid)": true] as [String : Any]
            
                ref.child("sheets/\(key)/tags").updateChildValues(tagsDictinary)
                
                for tag in self.tagsList {
                     ref.child("tags/\(tag.lowercased())/\(key)").setValue(true)
                }
                
                ref.updateChildValues(childUpdates, withCompletionBlock: { (error, refDatabase) in
                    if error == nil {
                        let refMember =  Database.database().reference().child("members/\(uid)")
                        refMember.observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let values = snapshot.value as? NSDictionary, let noteeCoins = values["noteeCoins"] as? Int else {return}
                            refMember.updateChildValues(["noteeCoins" : noteeCoins + 10])
                        })
                    }
                })
            })
            
            self.newPlug?.id = key
            self.newPlug?.urlImage = downloadURL?.absoluteString
            if self.foldersAlreadyCreated {
                self.delegate.sendPlug(plug: self.newPlug!)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func setupButtonValidate() {
        buttonValidate.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -spacesBeetweenTextFields).isActive = true
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
    
    var spacesBeetweenTextFields : CGFloat = 20
    
    func setupTextField() {
        
        
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: spacesBeetweenTextFields).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: spacesBeetweenTextFields).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        descriptionTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(disciplineTextField)
        disciplineTextField.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: spacesBeetweenTextFields).isActive = true
        disciplineTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        disciplineTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        disciplineTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(themeSheetTextField)
        themeSheetTextField.topAnchor.constraint(equalTo: disciplineTextField.bottomAnchor, constant: spacesBeetweenTextFields).isActive = true
        themeSheetTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        themeSheetTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        themeSheetTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(tagsTextField)
        tagsTextField.topAnchor.constraint(equalTo: themeSheetTextField.bottomAnchor, constant: spacesBeetweenTextFields).isActive = true
        tagsTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        tagsTextField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 60).isActive = true
        tagsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(sheetImage)
        sheetImage.topAnchor.constraint(equalTo: tagsTextField.bottomAnchor, constant: spacesBeetweenTextFields).isActive = true
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
