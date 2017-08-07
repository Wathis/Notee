//
//  ProfilController.swift
//  Notee
//
//  Created by Mathis Delaunay on 03/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class ProfilController: UIViewController, ChangeMailDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITableViewDelegate, UITableViewDataSource {
    
    
    let cellSignOut = "cellSignOut"
    let CELL_NEWS_ACTIVATE = "cellNewsActivate"
    let CELL_MAIL_ADDRESS = "cellAddressMail"
    let KEY_OF_SWITCH_NEWS = "enableNewsInfo"

    
    var newsParameterIsOn = true


    let DIMENSION_OF_PROFIL_IMAGE = CGFloat(100)
    
    var memberConnected : Member? {
        didSet {
            self.pseudoLabel.text = self.memberConnected?.pseudo
            self.profilImageView.image = self.memberConnected?.profilImage
        }
    }
    
    lazy var parametersTableView : UITableView = {
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
        imgView.layer.cornerRadius = CGFloat(self.DIMENSION_OF_PROFIL_IMAGE / 2)
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
        loadSettings()
        pickerImage.delegate = self
        self.parametersTableView.register(ParameterNewsOffOnCell.self, forCellReuseIdentifier: CELL_NEWS_ACTIVATE)
        self.parametersTableView.register(SignOutCell.self, forCellReuseIdentifier: cellSignOut)
        self.parametersTableView.register(ParameterCellEmail.self, forCellReuseIdentifier: CELL_MAIL_ADDRESS)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilImageView.isUserInteractionEnabled = true
        profilImageView.addGestureRecognizer(tapGestureRecognizer)
        self.navigationItem.title = "Mon profil"
    }
    
    func changeSettingNewsOnOff(_ sender : UISwitch) {
        let valueOfSwitch = sender.isOn
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(valueOfSwitch, forKey: KEY_OF_SWITCH_NEWS)
        userDefaults.synchronize()
    }
    
    func loadSettings() {
        guard let enableNews = UserDefaults.standard.value(forKey: KEY_OF_SWITCH_NEWS) as? Bool else {
            return
        }
        if (enableNews) {
            newsParameterIsOn = true
        } else {
            newsParameterIsOn = false
        }
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
        return section == 0 ? 2 : 1
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NEWS_ACTIVATE) as! ParameterNewsOffOnCell
                    if newsParameterIsOn {
                        cell.enableNews.setOn(true, animated: true)
                    }
                    cell.enableNews.addTarget(self, action: #selector(changeSettingNewsOnOff(_:)), for: .valueChanged)
                    return cell
                } else if (indexPath.row == 1) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MAIL_ADDRESS) as! ParameterCellEmail
                    cell.modifyAddressButton.addTarget(self, action: #selector(handleModifyAddress), for: .touchUpInside)
                    cell.labelMailAddress.text = self.memberConnected?.email
                    return cell
                }
            case 1:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellSignOut) as! SignOutCell
                    cell.buttonSignOut.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
                    return cell
                }
            default:
                return UITableViewCell()
        }
        
        return UITableViewCell()
        
    }
    func handleModifyAddress() {
        let controller = ChangeMailAddressController()
        controller.memberConnected = self.memberConnected
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func receiveMailChanged(email : String) {
        self.memberConnected?.email = email
        self.parametersTableView.reloadData()
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
        self.view.addSubview(parametersTableView)
        
        NSLayoutConstraint.activate([
            backgroundProfilView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : 0),
            backgroundProfilView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            backgroundProfilView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            backgroundProfilView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier : 2/5),
            
            profilImageView.topAnchor.constraint(equalTo: self.backgroundProfilView.topAnchor, constant : 20),
            profilImageView.centerXAnchor.constraint(equalTo: self.backgroundProfilView.centerXAnchor),
            profilImageView.widthAnchor.constraint(equalToConstant: DIMENSION_OF_PROFIL_IMAGE),
            profilImageView.heightAnchor.constraint(equalToConstant: DIMENSION_OF_PROFIL_IMAGE),
            
            pseudoLabel.topAnchor.constraint(equalTo: self.profilImageView.bottomAnchor, constant: 10),
            pseudoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pseudoLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            pseudoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            noteeCoinsIndicator.topAnchor.constraint(equalTo: self.view.topAnchor),
            noteeCoinsIndicator.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            noteeCoinsIndicator.heightAnchor.constraint(equalToConstant: 50),
            noteeCoinsIndicator.widthAnchor.constraint(equalToConstant: 80),
            
            parametersTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            parametersTableView.topAnchor.constraint(equalTo: self.backgroundProfilView.bottomAnchor, constant: 5),
            parametersTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            parametersTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
