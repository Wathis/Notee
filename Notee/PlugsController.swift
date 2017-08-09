//
//  PlugsController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class PlugsController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddingPlugDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIGestureRecognizerDelegate {

/*------------------------------------ CONSTANTS ---------------------------------------------*/

    let CELL_ID = "plugCell"
    
    
/*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    var theme : Theme?
    var discipline : String?
    var onePlug : Plug = Plug()
    var twoPlug : Plug = Plug()
    var plugs : [Plug] = []
    var timerAdd : Timer?
    var starActive = false
    
    
    lazy var plugsTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    var noSheets : UILabel = {
        let label = UILabel()
        label.text = "Aucune fiche"
        label.font = UIFont(name: "Helvetica", size: 20)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 86, g: 90, b: 97)
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicor : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(r: 86, g: 90, b: 98)
        return indicator
    }()
    
     let pickerImage = UIImagePickerController()
/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = theme?.name
        
        //FOR TEST
        setupIndicator()
        loadRevisionSheets()
        
        pickerImage.delegate = self
        //Setting the back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PlusButton"), style: .plain, target: self, action: #selector(handleAddButton))
        view.addSubview(plugsTableView)
        setupPlugsTableView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        addSwipeRecognizer()
    }
    
    func addSwipeRecognizer() {
        let direction: UISwipeGestureRecognizerDirection = .right
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        gesture.direction = direction
        self.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
/*---------------------------------- BACKEND FUNCTIONS ------------------------------------------*/

    func loadRevisionSheets() {
        guard let idOfTheme = theme?.id else {
            return
        }
        let ref = Database.database().reference().child("theme-sheets").child(idOfTheme)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let listOfSheets = snapshot.value as? NSDictionary else {
                self.finishLoad()
                return
            }
            for oneSheet in listOfSheets {
                guard let idOfSheet = oneSheet.key as? String else {
                    self.finishLoad()
                    return
                }
                let refSheets = Database.database().reference().child("sheets").child(idOfSheet)
                refSheets.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let informationOfSheet = snapshot.value as? NSDictionary else {return}
                    guard let description = informationOfSheet["description"] as? String,let discipline = informationOfSheet["discipline"] as? String , let title = informationOfSheet["title"] as? String, let theme = informationOfSheet["theme"] as? String ,let memberUID = informationOfSheet["memberUID"] as? String, let url = informationOfSheet["urlDownload"] as? String, let starsCount = informationOfSheet["starsCount"] as? Int, let interval = informationOfSheet["date"] as? Double else {
                        self.finishLoad()
                        return
                    }
                    let date = NSDate(timeIntervalSince1970: interval)
                    self.plugs.append(Plug(id: idOfSheet, discipline: discipline, description: description, theme: theme, title: title, member: Member(id: memberUID), urlPhoto :url , starsCount : starsCount, date: date))
                    self.finishLoad()
                })
            }
        })
    }
    
    func finishLoad() {
        if self.plugs.count == 0 {
            self.actualizeView(true)
        } else {
            self.actualizeView(false)
        }
    }
    
    func actualizeView(_ appearLabel : Bool) {
        if appearLabel {
            noSheets.isHidden = false
        } else {
            noSheets.isHidden = true
        }
        self.plugsTableView.reloadData()
        activityIndicor.stopAnimating()
        activityIndicor.removeFromSuperview()
    }

/*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
    
    //Function of protocol addingProtocole
    func sendPlug(plug : Plug){
        plugs.append(plug)
        let indexPath = IndexPath(row: plugs.count - 1, section: 0)
        timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(insertRow), userInfo: indexPath, repeats: false)
        self.noSheets.removeFromSuperview()
    }
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/

    func handleBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        
        guard let path = info[UIImagePickerControllerReferenceURL] as? URL else {
            return
        }
        let controller = addPlugController(foldersAlreadyCreated: true)
        controller.sheet = chosenImage
        controller.theme = self.theme
        controller.urlSheet = path
        controller.discipline = self.discipline
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: false, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAddButton() {
        pickerImage.sourceType = .photoLibrary
        pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(pickerImage, animated: true, completion: nil)
    }
    
/*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlugsCell = plugsTableView.dequeueReusableCell(withIdentifier: CELL_ID) as! PlugsCell
        if (indexPath.row % 2 == 0){
            cell.plugView.backgroundColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
            cell.titleSheet.textColor = .white
            cell.descriptionTextView.textColor = .white
        }
        cell.sheetTitle = self.plugs[indexPath.row].title
        cell.sheetDescription = self.plugs[indexPath.row].description
        return cell
    }
    func insertRow(timer : Timer) {
        plugsTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }

/*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = viewerController()
        controller.starActive = starActive
        controller.plug = plugs[indexPath.row]
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/
    
    func setupIndicator() {
        self.view.addSubview(activityIndicor)
        activityIndicor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicor.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicor.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicor.heightAnchor.constraint(equalToConstant: 40).isActive =  true
        
        activityIndicor.startAnimating()
        
        self.view.addSubview(noSheets)
        noSheets.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noSheets.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        noSheets.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        noSheets.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupPlugsTableView() {
        plugsTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        plugsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        plugsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plugsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        plugsTableView.register(PlugsCell.self, forCellReuseIdentifier: CELL_ID)
        plugsTableView.separatorStyle = .none
    }
    
}
