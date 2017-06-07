//
//  PlugsCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class PlugsCell: UITableViewCell {
    
    
/*------------------------------------ VARIABLES ---------------------------------------------*/

    var plugView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var sujetLabel : UILabel = {
        let label = UILabel()
        label.text = "Plug"
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 18)
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionTextView : UITextView = {
        let tf = UITextView()
        tf.isUserInteractionEnabled = false
        tf.backgroundColor = .clear
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        tf.textColor = UIColor(r: 86, g: 90, b: 98)
        tf.text = "This is a random text that i choose to represents a description of one plug."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
/*------------------------------------ CONSTRUCTORS ---------------------------------------------*/
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Remove the grey selection color
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor(r: 227, g: 231, b: 228)
        contentView.addSubview(plugView)
        setupPlugView()
        setupLabel()
        setupTextView()
    }
    
    
/*------------------------------------ CONSTRAINTS ---------------------------------------------*/
    
    func setupTextView() {
        descriptionTextView.topAnchor.constraint(equalTo: sujetLabel.bottomAnchor).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,constant : 7).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: sujetLabel.widthAnchor,constant: -7).isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: plugView.heightAnchor, multiplier: 3/5).isActive = true
    }
    
    func setupLabel() {
        sujetLabel.topAnchor.constraint(equalTo: plugView.topAnchor, constant: 10).isActive = true
        sujetLabel.centerXAnchor.constraint(equalTo: plugView.centerXAnchor, constant: 10).isActive = true
        sujetLabel.widthAnchor.constraint(equalTo: plugView.widthAnchor, constant: -30 ).isActive = true
        sujetLabel.heightAnchor.constraint(equalTo: plugView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupPlugView() {
        plugView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        plugView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        plugView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        plugView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant : -20).isActive = true
        plugView.addSubview(sujetLabel)
        plugView.addSubview(descriptionTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
