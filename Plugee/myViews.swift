//
//  myViews.swift
//  Plugee
//
//  Created by Mathis Delaunay on 16/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class PLTabBar : UIView {
    
    var isFavorite = false
    
    let commentButton : UIButton = {
        var button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "commenButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let favoriteButton : UIButton = {
        var button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "favoriteButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let numberOfCommentLabel : UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let numberOfFavoriteLabel : UILabel = {
        let label = UILabel()
        label.text = "14"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
/*------------------------------------ CONSTRUCTOR -----------------------------------------------------*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(r: 75, g: 199, b: 214)
        favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        self.addSubview(commentButton)
        self.addSubview(favoriteButton)
        self.addSubview(numberOfCommentLabel)
        self.addSubview(numberOfFavoriteLabel)
        setupCommentButton()
        setupFavoriteButton()
        setupNumberOfCommentLabel()
        setupNumberOfFavoriteLabel()
    }
    
/*------------------------------------ HANDLE FUNCTIONS --------------------------------------------------*/

    func handleFavorite() {
        changeFavoriteButtonStatus()
    }

/*------------------------------------ USEFULL FUNCTIONS --------------------------------------------------*/
    
    func changeFavoriteButtonStatus() {
        if !(isFavorite){
            numberOfFavoriteLabel.textColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
            favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favoriteButtonColored"), for: .normal)
            isFavorite = true
        }else {
            numberOfFavoriteLabel.textColor = .white
            favoriteButton.setBackgroundImage(#imageLiteral(resourceName: "favoriteButton"), for: .normal)
            isFavorite = false
        }
    }

/*------------------------------------ CONSTRAINT --------------------------------------------------*/
    
    func setupNumberOfCommentLabel() {
        numberOfFavoriteLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor).isActive = true
        numberOfFavoriteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        numberOfFavoriteLabel.widthAnchor.constraint(equalTo: commentButton.widthAnchor).isActive = true
        numberOfFavoriteLabel.heightAnchor.constraint(equalTo: commentButton.heightAnchor).isActive = true
    }
    
    func setupNumberOfFavoriteLabel() {
        numberOfCommentLabel.rightAnchor.constraint(equalTo: commentButton.leftAnchor).isActive = true
        numberOfCommentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        numberOfCommentLabel.widthAnchor.constraint(equalTo: commentButton.widthAnchor).isActive = true
        numberOfCommentLabel.heightAnchor.constraint(equalTo: commentButton.heightAnchor).isActive = true
    }
    
    func setupCommentButton() {
        commentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        commentButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        commentButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/5).isActive = true
        commentButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/5).isActive = true
    }
    
    func setupFavoriteButton() {
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        favoriteButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/5).isActive = true
        favoriteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 3/5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
