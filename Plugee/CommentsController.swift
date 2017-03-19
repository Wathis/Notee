//
//  CommentsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class CommentsController: UIViewController {

    
    let oneComment : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Pas de commentaires pour le moment..."
        label.numberOfLines = 2
        return label
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, b: 228, g: 231)
        self.navigationItem.title = "Comments"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.view.addSubview(oneComment)
        setupOneComment()
    }
    
     /*------------------------------------ HANDLE BUTTONS ---------------------------------------------*/
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupOneComment() {
        oneComment.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        oneComment.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        oneComment.widthAnchor.constraint(equalTo: self.view.widthAnchor ).isActive = true
        oneComment.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
