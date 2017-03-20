//
//  CommentsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class CommentsController: UIViewController,UITableViewDataSource {


    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    let cellId = "cellComment"
    
    lazy var commentsTableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor =  UIColor(r: 227, b: 228, g: 231)
        return tv
    }()
    
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
    
    let separatorLine : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(r: 75, b: 214, g: 199)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, b: 228, g: 231)
        self.navigationItem.title = "Comments"
        self.commentsTableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.view.addSubview(numberOfFavorite)
        self.view.addSubview(commentButton)
        self.view.addSubview(separatorLine)
        self.view.addSubview(commentsTableView)
        setupCommentButton()
        setupNumberOfFavorite()
        setupSeparatorLine()
        setupTableView()
    }
    
     /*------------------------------------ HANDLE BUTTONS ---------------------------------------------*/
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    /*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell = commentsTableView.dequeueReusableCell(withIdentifier: cellId) as! CommentCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
    
    func setupTableView() {
        commentsTableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor).isActive = true
        commentsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commentsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        let heightBeforeCell = (self.navigationController?.navigationBar.frame.height)! + numberOfFavorite.frame.height + separatorLine.frame.height
        commentsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: heightBeforeCell).isActive = true
    }
    
    func setupSeparatorLine(){
        separatorLine.topAnchor.constraint(equalTo: commentButton.bottomAnchor).isActive  = true
        separatorLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
