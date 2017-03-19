//
//  CommentsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class CommentsController: UIViewController {

    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    let numberOfFavorite : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "12 Favoris"
        label.textColor = UIColor(r: 75, b: 214, g: 199)
        return label
    }()
    
    let commentButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Commenter", for: .normal)
        button.setTitleColor(UIColor(r: 75, b: 214, g: 199), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, b: 228, g: 231)
        self.navigationItem.title = "Comments"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.view.addSubview(numberOfFavorite)
        self.view.addSubview(commentButton)
        setupCommentButton()
        setupNumberOfFavorite()
    }
    
     /*------------------------------------ HANDLE BUTTONS ---------------------------------------------*/
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNumberOfFavorite() {
        numberOfFavorite.topAnchor.constraint(equalTo: view.topAnchor, constant: (self.navigationController?.navigationBar.frame.height)! + 20).isActive = true
        numberOfFavorite.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        numberOfFavorite.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        numberOfFavorite.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCommentButton() {
        commentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: (self.navigationController?.navigationBar.frame.height)! + 20).isActive = true
        commentButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        commentButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
