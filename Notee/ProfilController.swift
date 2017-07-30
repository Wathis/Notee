//
//  ProfilController.swift
//  Notee
//
//  Created by Mathis Delaunay on 03/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class ProfilController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let widthHeightOfProfilImage = CGFloat(100)
    
    var member : Member? {
        didSet {
            self.pseudoLabel.text = self.member?.pseudo
        }
    }
    
    let backgroundProfilView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profilImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = CGFloat(self.widthHeightOfProfilImage / 2)
        imgView.image = #imageLiteral(resourceName: "backgroundProfilImage")
        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.borderWidth = 2
        return imgView
    }()
    
    let pseudoLabel : UILabel = {
        let label = UILabel()
        label.text = "@    "
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pickerImage = UIImagePickerController()
    
    let buttonSignOut = ButtonInMenus(text: "Déconnexion", backgroundColor: UIColor(r: 230, g: 135, b: 140))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        setupViews()
        loadUser()
        pickerImage.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilImageView.isUserInteractionEnabled = true
        profilImageView.addGestureRecognizer(tapGestureRecognizer)
        buttonSignOut.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        self.navigationItem.title = "Mon profil"
    }
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("members/\(uid)")
        ref.observe(.value ,with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {return}
            guard let pseudo = values["pseudo"] as? String, let urlImage = values["imageUrl"] as? String else {return}
            self.member = Member(id: uid, pseudo: pseudo, urlImage : urlImage)
            guard let checkedUrl = URL(string: urlImage) else {
                return
            }
            let download = DownloadFromUrl()
            download.downloadImage(url: checkedUrl, completion: { (image) in
                self.profilImageView.image = image
            })
        })
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        pickerImage.sourceType = .photoLibrary
        pickerImage.allowsEditing = true
        present(pickerImage, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilImageView.image = chosenImage
            self.uploadProfilImageChosen()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilImageChosen() {
        guard let uid = Auth.auth().currentUser?.uid, let photo = self.profilImageView.image else {
            return
        }
        self.profilImageView.isUserInteractionEnabled = false
        let ref = Database.database().reference().child("members/\(uid)")
        
        let storageRef = Storage.storage().reference()
        
        let refStorage = storageRef.child("profilImages/\(uid)")
        
        
        guard let uploadData = UIImageJPEGRepresentation(photo, 0.1) else {
            return
        }
        
        refStorage.putData(uploadData, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!)
                return
            }
            let downloadURL = metadata!.downloadURL()
            
            let values = ["imageUrl" : downloadURL?.absoluteString] as! [String : String]
            ref.updateChildValues(values)
            self.profilImageView.isUserInteractionEnabled = true
        }
    }
    
    func handleLogout () {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        present(ConnectionController(), animated: true, completion: nil)
    }

    func setupViews() {
        
        self.view.addSubview(backgroundProfilView)
        backgroundProfilView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 0).isActive = true
        backgroundProfilView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backgroundProfilView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        backgroundProfilView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier : 2/5).isActive = true
        
        self.backgroundProfilView.addSubview(profilImageView)
        profilImageView.topAnchor.constraint(equalTo: self.backgroundProfilView.topAnchor, constant : 20).isActive = true
        profilImageView.centerXAnchor.constraint(equalTo: self.backgroundProfilView.centerXAnchor).isActive = true
        profilImageView.widthAnchor.constraint(equalToConstant: widthHeightOfProfilImage).isActive = true
        profilImageView.heightAnchor.constraint(equalToConstant: widthHeightOfProfilImage).isActive = true
        
        self.view.addSubview(pseudoLabel)
        pseudoLabel.topAnchor.constraint(equalTo: self.profilImageView.bottomAnchor, constant: 10).isActive = true
        pseudoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pseudoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pseudoLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(buttonSignOut)
        buttonSignOut.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        buttonSignOut.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true
        buttonSignOut.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSignOut.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
