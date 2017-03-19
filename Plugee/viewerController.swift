//
//  viewerController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class viewerController: UIViewController {
    
    /*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    /*------------------------------------ VARIABLES ---------------------------------------------*/
    
    var image : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "plugExample")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Plug"
        self.view.addSubview(image)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PlusButton"), style: .plain, target: self, action: #selector(handlePlus))
        setupImage()
    }
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handlePlus() {
        print("Handle plus")
    }

/*------------------------------------ CONSTRAINT --------------------------------------------------*/

    func setupImage() {
        let heightOfStatusBar = UIApplication.shared.statusBarFrame.height
        if let heightOfNavbar = self.navigationController?.navigationBar.frame.height {
            image.topAnchor.constraint(equalTo: view.topAnchor,constant: heightOfNavbar + heightOfStatusBar).isActive = true
            image.heightAnchor.constraint(equalTo: view.heightAnchor,constant: -heightOfNavbar - heightOfStatusBar).isActive = true
            
        }else {
            image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            image.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }

}
