//
//  keywordCell.swift
//  Notee
//
//  Created by Mathis Delaunay on 04/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

class TagsCell : UICollectionViewCell {
    
    
    var deleteButton  : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "croix"), for: .normal)
        return button
    }()
    
    var label : UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        label.textColor = UIColor(red:86 / 255,green:90 / 255,blue:98 / 255,alpha : 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(deleteButton)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -10)
            
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FooterTagsTextField : UICollectionReusableView {
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = UIColor(r: 86, g: 90, b: 98)
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        tf.placeholder = "Entrez un mot clé"
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier : 9/10),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    
    
    //////////////////////////////////////////////////////////////////////////////
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}



