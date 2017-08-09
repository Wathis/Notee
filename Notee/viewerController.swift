//
//  viewerController.swift
//  Notee
//
//  Created by Mathis Delaunay on 19/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class viewerController: UIViewController, UIScrollViewDelegate  {
    
//    /*------------------------------------ CONSTANTS ---------------------------------------------*/
//    
    let heightOfTabBar: CGFloat = 45

    /*------------------------------------ VARIABLES ---------------------------------------------*/
    
    
    var plug : Plug? {
        didSet {
            self.imageView.image = plug?.photo
        }
    }
    
    var starActive = false {
        didSet {
            self.tabBar.isFavorite = starActive
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 4.0
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    
    var imageView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "plugExample")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var tabBar : PLTabBar = {
        let tabBar = PLTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    let activityIndicor : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(r: 86, g: 90, b: 98)
        return indicator
    }()
    
    /*------------------------------------ VIEW DID LOAD ---------------------------------------------*/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = self.plug?.title ?? "Fiche"
        self.view.addSubview(imageView)
        self.view.addSubview(tabBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "BackButton"), style: .plain, target: self, action: #selector(handleBack))
        loadFavorite()
        setupTabBar()
        setupImage()
        loadCommentsNumber()
        observeStarsCount()
        tabBar.favoriteButton.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        tabBar.commentButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        addSwipeRecognizer()
        guard let checkedUrl = URL(string: (plug?.urlImage!)!) else {
            return
        }
        let download = DownloadFromUrl()
        download.downloadImage(url: checkedUrl, completion: { (image) in
            self.activityIndicor.stopAnimating()
            self.activityIndicor.removeFromSuperview()
            self.plug?.photo = image
        })
    }
    
    func addSwipeRecognizer() {
        let direction: UISwipeGestureRecognizerDirection = .down
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        gesture.direction = direction
        self.view.addGestureRecognizer(gesture)
    }
    
    func handleSwipe() {
        dismiss(animated: true, completion: nil)
    }
/*------------------------------------- HANDLE BUTTONS --------------------------------------------*/
    func handleFavorite() {
        if self.plug?.starsCount != nil {
            if (starActive){
                self.updateFavorite()
                self.tabBar.handleFavorite()
                starActive = false
            } else {
                self.updateFavorite()
                self.tabBar.handleFavorite()
                starActive = true
            }
        }
    }
    
    func loadCommentsNumber() {
        self.tabBar.numberOfCommentLabel.text = "0"
        guard let idOfPlug = self.plug?.id else {return}
        let ref = Database.database().reference().child("comments-sheets/\(idOfPlug)")
        ref.observe(.value, with: { (snapshot) in
            var numberOfComments = 0
            guard let values = snapshot.value as? NSDictionary else {return}
            for _ in values {
                numberOfComments += 1
            }
            self.tabBar.numberOfCommentLabel.text = "\(numberOfComments)"
            return
        })
    }
    
    func loadFavorite() {
        guard let uid = Auth.auth().currentUser?.uid, let sheetId = self.plug?.id else {return}
        let refSheets = Database.database().reference().child("sheets").child(sheetId)
        refSheets.child("star").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary, let _ = values[uid] else {
                return
            }
            self.starActive = true
            self.tabBar.loadRightColorOfStar()
        })
    }
    
    func observeStarsCount() {
        guard let idOfPlug = self.plug?.id else {return}
        Database.database().reference().child("sheets/\(idOfPlug)/starsCount").observe(.value, with: { (snapshot) in
            guard let count = snapshot.value as? Int else {return}
            self.plug?.starsCount = count
            self.tabBar.nbrOfStars = count
        })
    }
    
    func updateFavorite(){
        guard let idOfPlug = self.plug?.id ,let uid = Auth.auth().currentUser?.uid, let starCount = self.plug?.starsCount, let uidOfPlug = self.plug?.member?.id else {return}
        
        if starActive {
             Database.database().reference().child("sheets/\(idOfPlug)/star/\(uid)").removeValue()
             Database.database().reference().child("sheets/\(idOfPlug)/starsCount").setValue(starCount - 1)
             Database.database().reference().child("members/\(uidOfPlug)/noteeCoins").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? Int else {return}
                Database.database().reference().child("members/\(uidOfPlug)/noteeCoins").setValue(value - 1)
             })
        } else {
            Database.database().reference().child("sheets/\(idOfPlug)/star/\(uid)").setValue(true)
            Database.database().reference().child("sheets/\(idOfPlug)/starsCount").setValue(starCount + 1)
            Database.database().reference().child("members/\(uidOfPlug)/noteeCoins").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? Int else {return}
                Database.database().reference().child("members/\(uidOfPlug)/noteeCoins").setValue(value + 1)
            })
        }
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleComment() {
        let controller = CommentsController()
        controller.plug = self.plug
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
/*------------------------------------ DOWNLOAD --------------------------------------------------*/

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
/*------------------------------------ CONSTRAINT --------------------------------------------------*/

    func setupImage() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant : -heightOfTabBar).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        
        self.view.addSubview(activityIndicor)
        activityIndicor.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        activityIndicor.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        activityIndicor.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicor.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.activityIndicor.startAnimating()
    }
    
    func setupTabBar() {
        tabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tabBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: heightOfTabBar).isActive = true
        
        guard let nbrOfFavorite = self.plug?.starsCount else {return}
        self.tabBar.nbrOfStars = nbrOfFavorite
    }
}
