//
//  TopNewsCell.swift
//  Plugee
//
//  Created by Mathis Delaunay on 25/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class TopNewsCell: UIView {
    
    private let grayColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
    private let turquoiseColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
    
    var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Il n'y a pas de news pour le moment..."
        return label
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        setupLabel()
        setupView()
    }
    
    func setupView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    func randomBackgroundColor(number : Int) {
        if (number % 2 == 0){
            self.backgroundColor = grayColor
            self.label.textColor = .white
        }else {
            self.backgroundColor = .white
            self.label.textColor = grayColor
        }
    }
    
    func setupLabel() {
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier : 9/10).isActive = true
        label.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier : 4/5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
