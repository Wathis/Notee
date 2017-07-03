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
    var plug : Plug? {
        didSet {
            self.image.image = plug?.photo
        }
    }
    
    /*------------------------------------ VARIABLES ---------------------------------------------*/
    
    var image : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "plugExample")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor(r: 227, g: 228, b: 231)
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
        guard let checkedUrl = URL(string: (plug?.urlImage!)!) else {
            return
        }
        downloadImage(url: checkedUrl)
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
    
/*------------------------------------ DOWNLOAD --------------------------------------------------*/
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.plug?.photo = UIImage(data: data)
            }
        }
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
