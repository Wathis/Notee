//
//  ClassCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 13/04/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    var viewInContentView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 1
        return view
    }()
    
    var label : UILabel = {
        var label = UILabel()
        label.attributedText = NSAttributedString(string: "Classe", attributes: [NSForegroundColorAttributeName : UIColor(r:86,g:90,b:98) as Any , NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15) as Any])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String? ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Remove the grey selection color
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        contentView.addSubview(viewInContentView)
        contentView.addSubview(label)
        setupViews()
    }
    
    func setText(text : String) {
        label.attributedText = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor(r:86,g:90,b:98) as Any , NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15) as Any])
    }
    
    func setupViews() {
        viewInContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        viewInContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        viewInContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4/5).isActive = true
        viewInContentView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: viewInContentView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
