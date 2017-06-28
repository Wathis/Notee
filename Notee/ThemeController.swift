//
//  SectionsController.swift
//  Notee
//
//  Created by Mathis Delaunay on 15/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class ThemeController : UIViewController, UITableViewDataSource,UITableViewDelegate,AddingThemeDelegate {
    
/*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    let reuseIdentifier = "cellSections"
    
/*------------------------------------ VARIABLES ---------------------------------------------*/
    
    var themes : [String] = []
    var timerAdd : Timer?
    var discipline : String?

    
    lazy var themeTableView : UITableView = {
        var tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var noTheme : UILabel = {
        let label = UILabel()
        label.text = "Aucune matière"
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

/*------------------------------------ VIEW DID LOAD ---------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        //Set title avec the nav bar
        self.navigationItem.title = "Thème"
        loadTheme()
        setupIndicator()
        //Setting the back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PlusButton"), style: .plain, target: self, action: #selector(handleAddButton))
        view.addSubview(themeTableView)
        setupTableView()
    }
    
/*---------------------------------- BACK END FUNCTIONS -------------------------------------------*/
    
    func loadTheme() {
        
        guard let uid = Auth.auth().currentUser?.uid, let disciplineData = discipline else {
            return
        }
        let ref = Database.database().reference().child("members-themes")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(disciplineData) {
                        ref.child(uid).child(disciplineData).observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let values = snapshot.value as? NSDictionary else {
                                return
                            }
                            for value in values {
                                if let key = value.key as? String  {
                                    self.themes.append(key)
                                }
                            }
                            self.actualizeView(false)
                        })
                    } else {
                        self.actualizeView(true)
                    }
                })
            } else {
                self.actualizeView(true)
            }
        })
    }
    
    func actualizeView(_ appearLabel : Bool) {
        if appearLabel {
            noTheme.isHidden = false
        }
        self.themeTableView.reloadData()
        activityIndicor.stopAnimating()
        activityIndicor.removeFromSuperview()
    }
    
    func addNewTheme(themeName: String) {
        guard let uid = Auth.auth().currentUser?.uid, let disciplineData = self.discipline else {
            return
        }
        let ref  = Database.database().reference().child("members-themes").child(uid).child(disciplineData)
        let value = [themeName : true]
        ref.updateChildValues(value) { (error, refDatabase) in
            if error != nil {
                print(error!)
                return
            }
            self.themes.append(themeName)
            let indexPath = IndexPath(row: self.themes.count - 1, section: 0)
            self.timerAdd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.insertRow), userInfo: indexPath, repeats: false)
        }
    }
    
/*---------------------------------- PROTOCOLS FUNCTIONS ------------------------------------------*/
    //Function of protocol addingProtocole
    func sendTheme(theme: String) {
        addNewTheme(themeName: theme)
    }

/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/

    func handleAddButton() {
        let controller = addThemeController()
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func handleBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
/*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    //NUMBER OF ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }
    //SIZE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //CELL GESTION
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SectionsCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)! as! SectionsCell
        cell.labelSection.text = self.themes[indexPath.row]
        if (indexPath.row % 2 == 0) {
            cell.viewInContentView.backgroundColor =  UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
            cell.labelSection.textColor = .white
        }else {
            cell.backgroundColor = .white
        }
        return cell
        
    }
    func insertRow(timer : Timer) {
        themeTableView.insertRows(at: [timer.userInfo as! IndexPath], with: .automatic)
    }
    
/*---------------------------------- TABLE VIEW DELEGATE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PlugsController()
        controller.section = themes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/

    func setupIndicator() {
        self.view.addSubview(activityIndicor)
        activityIndicor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicor.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicor.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicor.heightAnchor.constraint(equalToConstant: 40).isActive =  true
        
        activityIndicor.startAnimating()
        
        self.view.addSubview(noTheme)
        noTheme.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        noTheme.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
        noTheme.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        noTheme.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupTableView() {
        themeTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        themeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        themeTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        themeTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        themeTableView.register(SectionsCell.self, forCellReuseIdentifier: reuseIdentifier)
        themeTableView.separatorStyle = .none
    }
}
