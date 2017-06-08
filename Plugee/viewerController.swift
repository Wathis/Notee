//
//  viewerController.swift
//  Notee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class viewerController: UIViewController {
    
    /*------------------------------------ CONSTANTS ---------------------------------------------*/
    
    let heightOfTabBar: CGFloat = 45
    
    /*------------------------------------ VARIABLES ---------------------------------------------*/
    
    var image : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "plugExample")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var tabBar : PLTabBar = {
        let tabBar = PLTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Plug"
        self.view.addSubview(image)
        self.view.addSubview(tabBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PlusButton"), style: .plain, target: self, action: #selector(handlePlus))
        setupTabBar()
        setupImage()
        tabBar.commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
    }
    
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handlePlus() {
        print("Handle plus")
    }
    
    func handleComment() {
        let controller = CommentsController()
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }

/*------------------------------------ CONSTRAINT --------------------------------------------------*/

    func setupImage() {
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant : -heightOfTabBar).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setupTabBar() {
        tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tabBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: heightOfTabBar).isActive = true
    }
}
