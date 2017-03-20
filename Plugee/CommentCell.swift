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
        imgview.layer.cornerRadius = 15
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.contentMode = .scaleAspectFit
        imgview.layer.masksToBounds = true
        return imgview
    }()
    
    let separatorLine : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(r: 75, b: 214, g: 199)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(r: 227, b: 228, g: 231)
        self.addSubview(profilImage)
        self.addSubview(separatorLine)
        setupProfilImage()
        setupSeparatorLine()
    }
    
    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
    
    func setupProfilImage() {
        profilImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        profilImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        profilImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        profilImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupSeparatorLine(){
        separatorLine.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant : -5).isActive  = true
        separatorLine.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1 ).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
