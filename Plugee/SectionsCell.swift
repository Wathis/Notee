//
//  SectionsCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 15/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class SectionsCell: UITableViewCell {

    var labelSection : UILabel = {
        let label = UILabel()
        label.text = "Null"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewInContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 1
        view.layer.masksToBounds = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Remove the grey selection color
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor(r: 227, g: 231, b: 228)
        contentView.addSubview(viewInContentView)
        setupViewInContentView()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViewInContentView() {
        viewInContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        viewInContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        viewInContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant : -20).isActive = true
        viewInContentView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewInContentView.addSubview(labelSection)
    }
    
    func setupLabel() {
        labelSection.centerXAnchor.constraint(equalTo: viewInContentView.centerXAnchor, constant: 0).isActive = true
        labelSection.centerYAnchor.constraint(equalTo: viewInContentView.centerYAnchor, constant: 0).isActive = true
        labelSection.widthAnchor.constraint(equalTo: viewInContentView.widthAnchor).isActive = true
        labelSection.heightAnchor.constraint(equalTo: viewInContentView.heightAnchor).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
