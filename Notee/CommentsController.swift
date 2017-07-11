//
//  CommentsController.swift
//  Notee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Firebase
import UIKit

class CommentsController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {


    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    let cellId = "cellComment"
    var comments = [Comment]()
    var plug : Plug? {
        didSet {
            guard let nbrOfStars = self.plug?.starsCount else {return}
            self.numberOfFavorite.text = "\(nbrOfStars) favoris"
        }
    }
    var member : Member?
    
    
    lazy var commentsTableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor =  UIColor(r: 227, g: 231, b: 228)
        return tv
    }()
    
    let numberOfFavorite : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "12 Favoris"
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        return label
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(r: 86, g: 90, b: 98)
        view.layer.opacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let commentTextFieldContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        return view
    }()
    
    var commentTextField : UITextField = {  
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(string: "Écrire un commentaire...", attributes: [NSForegroundColorAttributeName : UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)])
        tf.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        return tf
    }()
    
    let buttonGo : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
        return button
    }()
    
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "Comments"
        hideKeyboardWhenTappedAround()
        self.commentsTableView.register(CommentCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.view.addSubview(numberOfFavorite)
        self.view.addSubview(separatorLine)
        self.view.addSubview(commentsTableView)
        self.view.addSubview(commentTextFieldContainerView)
        setupNumberOfFavorite()
        setupSeparatorLine()
        setupTableView()
        setupContainerView()
        loadComments()
        loadUser()
        self.commentTextField.delegate = self
        buttonGo.addTarget(self, action: #selector(handleGo), for: .touchUpInside)
        
        //Observer on keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotificationWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
     /*------------------------------------ HANDLE BUTTONS ---------------------------------------------*/
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.handleGo()
        return true
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame : CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomLayout?.constant = -keyboardFrame.size.height
            })
            self.commentTextField.layoutIfNeeded()
        }
    }
    
    func handleKeyboardNotificationWillHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomLayout?.constant = 0
        })
        self.commentTextFieldContainerView.layoutIfNeeded()
    }
    
    /*---------------------------------- TABLE VIEW DATA SOURCE ----------------------------------------*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell = commentsTableView.dequeueReusableCell(withIdentifier: cellId) as! CommentCell
        cell.commentLabel.text = comments[indexPath.row].commentText
        let member = comments[indexPath.row].member
        cell.profilImage.image = #imageLiteral(resourceName: "defaultProfilImage")
        cell.nameLabel.text = member?.pseudo
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
     /*---------------------------------- FUNCTIONS BACKEND ----------------------------------------*/

    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("members/\(uid)")
        ref.observe(.value ,with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {return}
            guard let pseudo = values["pseudo"] as? String, let urlImage = values["imageUrl"] as? String else {return}
            self.member = Member(id: uid, pseudo: pseudo, urlImage : urlImage)
            self.member?.profilImage = #imageLiteral(resourceName: "defaultProfilImage")
        })
    }
    
    func loadComments() {
//        var interval = NSDate().timeIntervalSince1970
        guard let idOfPlug = self.plug?.id , let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("comments-sheets/\(idOfPlug)")
        ref.observe(.value, with: { (snapshot) in
            self.comments.removeAll()
            guard let values = snapshot.value as? NSDictionary else {return}
            for value in values {
                guard let dataOfComment = value.value as? NSDictionary ,  let pseudo = dataOfComment["pseudo"] as? String, let comment = dataOfComment["comment"] as? String, let interval = dataOfComment["date"] as? String else {
                    return
                }
                let date = NSDate(timeIntervalSince1970: Double(interval)!)
                self.comments.append(Comment(member: Member(id: uid,pseudo: pseudo), date : date, commentText: comment))
            }
            self.sortComments()
            self.commentsTableView.reloadData()
            return
        })
    }
    
    func sortComments() {
        comments = comments.sorted(by: {$0.date!.timeIntervalSinceNow < $1.date!.timeIntervalSinceNow})
    }
    
    func handleGo () {
        let interval = NSDate().timeIntervalSince1970
        let date = NSDate(timeIntervalSince1970: interval)
        guard let member = self.member, let commentText = self.commentTextField.text else {return}
        if commentText.characters.count > 0 {
            let comment = Comment(member: member, date : date, commentText: commentText)
            comments.append(comment)
            self.newComment(comment : comment)
            let indexPath = IndexPath(row: comments.count - 1, section: 0)
            commentsTableView.insertRows(at: [indexPath], with: .automatic)
            commentTextField.text = nil
            view.endEditing(true)
        }
    }
    
    func newComment(comment : Comment) {
        guard let idOfPlug = self.plug?.id, let pseudo = comment.member?.pseudo, let imageUrl = comment.member?.profilImageUrl, let commentText = comment.commentText, let date = comment.date else {return}
        let refComments = Database.database().reference().child("comments-sheets/\(idOfPlug)/").childByAutoId()
        let values : [String : String] = ["comment" : commentText,"pseudo": pseudo,"imageUrl" : imageUrl, "date" : "\(date.timeIntervalSince1970)"]
        
        refComments.updateChildValues(values, withCompletionBlock: { (error,refDatabase) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        })
    }
    
    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
    
    var bottomLayout : NSLayoutConstraint?
    var widthButtonGo  = CGFloat(40)
    func setupContainerView() {
        bottomLayout = commentTextFieldContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomLayout?.isActive = true
        commentTextFieldContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commentTextFieldContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        commentTextFieldContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.commentTextFieldContainerView.addSubview(commentTextField)
        self.commentTextFieldContainerView.addSubview(buttonGo)
        
        commentTextField.centerYAnchor.constraint(equalTo: self.commentTextFieldContainerView.centerYAnchor).isActive = true
        commentTextField.leftAnchor.constraint(equalTo: self.commentTextFieldContainerView.leftAnchor, constant : 10).isActive = true
        commentTextField.widthAnchor.constraint(equalTo: commentTextFieldContainerView.widthAnchor, constant : -widthButtonGo).isActive = true
        commentTextField.heightAnchor.constraint(equalTo: commentTextFieldContainerView.heightAnchor).isActive = true
        
        buttonGo.rightAnchor.constraint(equalTo: self.commentTextFieldContainerView.rightAnchor).isActive = true
        buttonGo.lastBaselineAnchor.constraint(equalTo: commentTextField.lastBaselineAnchor).isActive = true
        buttonGo.heightAnchor.constraint(equalTo: self.commentTextFieldContainerView.heightAnchor).isActive = true
        buttonGo.widthAnchor.constraint(equalToConstant: widthButtonGo).isActive = true
    }
    
    
    func setupTableView() {
        commentsTableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor).isActive = true
        commentsTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        commentsTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        let heightBeforeCell = (self.navigationController?.navigationBar.frame.height)! + numberOfFavorite.frame.height + separatorLine.frame.height
        commentsTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -2*heightBeforeCell).isActive = true
    }
    
    func setupSeparatorLine(){
        separatorLine.topAnchor.constraint(equalTo: numberOfFavorite.bottomAnchor).isActive  = true
        separatorLine.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1/2).isActive = true
    }
    
    func setupNumberOfFavorite() {
        numberOfFavorite.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        numberOfFavorite.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        numberOfFavorite.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        numberOfFavorite.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
}
