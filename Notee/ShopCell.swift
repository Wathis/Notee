//
//  ShopCell.swift
//  Notee
//
//  Created by Mathis Delaunay on 06/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class ShopCell: UICollectionViewCell {
    
    let sizeOfNoteeCoins = CGFloat(25)
    
    var price : String? {
        didSet {
            self.titleOfNewPlug.text = price
        }
    }
    
    var noteeCoins : String? {
        didSet {
            self.labelNumberNoteeCoins.text = noteeCoins
        }
    }
    
    var titleOfNewPlug : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var underHeaderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 86, g: 90, b: 98)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    let noteeImage : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "noteeCoinsShop")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelNumberNoteeCoins : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(r: 86, g: 90, b: 98)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupViews()
        setShadowToView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShadowToView() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5
    }
    
    func setupViews() {
        
        self.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 8/10).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.addSubview(underHeaderView)
        
        underHeaderView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        underHeaderView.widthAnchor.constraint(equalTo: headerView.widthAnchor).isActive = true
        underHeaderView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1/2).isActive = true
        underHeaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier : 8/10).isActive = true
        
        self.addSubview(titleOfNewPlug)
        
        titleOfNewPlug.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleOfNewPlug.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleOfNewPlug.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 9/10).isActive = true
        titleOfNewPlug.heightAnchor.constraint(equalTo: self.headerView.heightAnchor).isActive = true
        
        self.addSubview(labelNumberNoteeCoins)
        
        labelNumberNoteeCoins.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelNumberNoteeCoins.heightAnchor.constraint(equalToConstant: 40).isActive = true
        labelNumberNoteeCoins.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -15).isActive = true
        labelNumberNoteeCoins.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        self.addSubview(noteeImage)
        
        noteeImage.widthAnchor.constraint(equalToConstant: sizeOfNoteeCoins).isActive = true
        noteeImage.heightAnchor.constraint(equalToConstant: sizeOfNoteeCoins).isActive = true
        noteeImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 28).isActive = true
        noteeImage.centerYAnchor.constraint(equalTo: labelNumberNoteeCoins.centerYAnchor).isActive = true
    }
    
}

extension ShopCell {
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        userClicked()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userTapped()
    }
    
    func userClicked() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func userTapped() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finish) in
            
        }
    }
}
