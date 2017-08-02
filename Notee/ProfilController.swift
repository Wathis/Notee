//
//  ProfilController.swift
//  Notee
//
//  Created by Mathis Delaunay on 03/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class ProfilController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITableViewDelegate, UITableViewDataSource {
    
    
    let cellSignOut = "cellSignOut"
    let cellNewsActivate = "cellNewsActivate"



    let widthHeightOfProfilImage = CGFloat(100)
    
    var member : Member? {
        didSet {
            self.pseudoLabel.text = self.member?.pseudo
        }
    }
    
    lazy var parametersCollectionView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundProfilView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor(r: 0, g: 0, b: 0).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 1
        return view
    }()
    
    lazy var profilImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = CGFloat(self.widthHeightOfProfilImage / 2)
        imgView.image = #imageLiteral(resourceName: "backgroundProfilImage")
        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor(r: 86, g: 90, b: 98).cgColor
        imgView.layer.borderWidth = 4
        return imgView
    }()
    
    let pseudoLabel : UILabel = {
        let label = UILabel()
        label.text = "@    "
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    let noteeCoinsIndicator : NoteeCoinsIndicator = {
        let noteeCoinsIndicator  = NoteeCoinsIndicator()
        noteeCoinsIndicator.translatesAutoresizingMaskIntoConstraints = false
        return noteeCoinsIndicator
    }()
    
    let pickerImage = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        setupViews()
        loadUser()
        loadSettings()
        pickerImage.delegate = self
        self.parametersCollectionView.register(ParameterNewsOffOnCell.self, forCellReuseIdentifier: cellNewsActivate)
        self.parametersCollectionView.register(SignOutCell.self, forCellReuseIdentifier: cellSignOut)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilImageView.isUserInteractionEnabled = true
        profilImageView.addGestureRecognizer(tapGestureRecognizer)
        self.navigationItem.title = "Mon profil"
    }
    
    func loadSettings() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(false, forKey: "enableNewsInfo")
        userDefaults.synchronize()
        
        if let enableNews = userDefaults.value(forKey: "enableNewsInfo") as? Bool {
            if (enableNews) {
                
            }
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Parametres"
        } else if (section == 1) {
            return ""
        } else {
            return ""
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellNewsActivate) as! ParameterNewsOffOnCell
                    return cell
                }
            case 1:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellSignOut) as! SignOutCell
                    return cell
                }
            default:
                return UITableViewCell()
        }
        
        return UITableViewCell()
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        } else {
            return 45
        }
    }

    func setupViews() {
        
        self.view.addSubview(backgroundProfilView)
        self.backgroundProfilView.addSubview(profilImageView)
        self.view.addSubview(pseudoLabel)
        self.backgroundProfilView.addSubview(noteeCoinsIndicator)
        self.view.addSubview(parametersCollectionView)
        
        NSLayoutConstraint.activate([
            backgroundProfilView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 0),
            backgroundProfilView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundProfilView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            backgroundProfilView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier : 2/5),
            
            profilImageView.topAnchor.constraint(equalTo: self.backgroundProfilView.topAnchor, constant : 20),
            profilImageView.centerXAnchor.constraint(equalTo: self.backgroundProfilView.centerXAnchor),
            profilImageView.widthAnchor.constraint(equalToConstant: widthHeightOfProfilImage),
            profilImageView.heightAnchor.constraint(equalToConstant: widthHeightOfProfilImage),
            
            pseudoLabel.topAnchor.constraint(equalTo: self.profilImageView.bottomAnchor, constant: 10),
            pseudoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pseudoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            pseudoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            noteeCoinsIndicator.topAnchor.constraint(equalTo: self.view.topAnchor),
            noteeCoinsIndicator.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            noteeCoinsIndicator.heightAnchor.constraint(equalToConstant: 50),
            noteeCoinsIndicator.widthAnchor.constraint(equalToConstant: 80),
            
            parametersCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            parametersCollectionView.topAnchor.constraint(equalTo: self.backgroundProfilView.bottomAnchor, constant: 5),
            parametersCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            parametersCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
