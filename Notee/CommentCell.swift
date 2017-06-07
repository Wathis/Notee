//
//  CommentCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 20/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    /*--------------------------------------- VARIABLES ---------------------------------------------*/
    
    let profilImage : UIImageView = {
        let imgview = UIImageView()
        imgview.image = #imageLiteral(resourceName: "mathisProfilImage")
        imgview.layer.cornerRadius = 10
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.layer.masksToBounds = false
        imgview.clipsToBounds = true
        return imgview
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(r: 86, g: 90, b: 98)
        view.layer.opacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "@MathisDelaunay"
        label.font = UIFont.systemFont(ofSize: 15, weight : UIFontWeightBold)
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentLabel : UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.text = "This comment had been post by me in the comment section"
        tv.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(r: 227, g: 231, b: 228)
        self.addSubview(profilImage)
        self.addSubview(nameLabel)
        self.addSubview(separatorLine)
        self.addSubview(commentLabel)
        self.selectionStyle = .none
        setupProfilImage()
        setupSeparatorLine()
        setupLabelName()
        setupCommentLabel()
    }
    
    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
    
    func setupCommentLabel() {
        commentLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        commentLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/5).isActive = true
    }
    
    func setupLabelName(){
        nameLabel.leftAnchor.constraint(equalTo: profilImage.rightAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupProfilImage() {
        profilImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        profilImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        profilImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/5).isActive = true
        profilImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 2/5).isActive = true
    }
    
    func setupSeparatorLine(){
        separatorLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant : -5).isActive  = true
        separatorLine.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1/2 ).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
