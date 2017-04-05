//
//  NewsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class NewsController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    let heightOfNewsCell : CGFloat = 100
    var timerForNews = Timer()
    var plugeeNews = ["Plugee permet de partager vos fiches de révision !","Ajoutez à vos favoris les fiches de vos amis !"
        ,"Pourquoi ne pas invitez vos amis a rejoindre Plugee ?","Vous ne savez pas comment utiliser Plugee ? Cliquez ici !"]
    var newPlugs : [Plug]?
    
    
//    lazy var newsCarousel : iCarousel = {
//        var carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 120, height: 10))
//        carousel.translatesAutoresizingMaskIntoConstraints = false
//        carousel.delegate = self
//        carousel.dataSource = self
//        carousel.type = .cylinder
//        carousel.scrollSpeed = 2
//        carousel.isPagingEnabled = true
//        return carousel
//    }()
    
//    lazy var newPlugsCarousel : iCarousel = {
//        var carousel = iCarousel()
//        carousel.translatesAutoresizingMaskIntoConstraints = false
//        carousel.delegate = self
//        carousel.dataSource = self
//        carousel.type = .cylinder
//        carousel.scrollSpeed = 2
//        carousel.isPagingEnabled = true
//        return carousel
//    }()
    
    lazy var newsView : TopNewsCell = {
        let myView = TopNewsCell()
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.randomBackgroundColor(number: 0)
        return myView
    }()
    
    let myView : newPlugView = {
        let view = newPlugView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        timerForNews = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(nextNews), userInfo: nil, repeats: true)
//    }
//    
//    func nextNews() {
//        if (newPlugsCarousel.currentItemIndex + 1 > plugeeNews.count){
//            newPlugsCarousel.scrollToItem(at: 0, animated: true)
//        }else {
//            newPlugsCarousel.scrollToItem(at: newPlugsCarousel.currentItemIndex + 1, animated: true)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        timerForNews.invalidate()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "News"
        addPlugsToArray()
        self.view.addSubview(newsView)
        setupMyView()
    }
    
    func addPlugsToArray() {
        let memberHarvey = Member(nom: "Roberts", prenom: "Harvey", pseudo: "@harveyroberts",profilImage : #imageLiteral(resourceName: "harveyProfilImage"))
        newPlugs?.append(Plug(id: 12565, description: "Ce plug est une prise de note de mon cours sur la bataille de verdun", title: "La bataille de verdun", photo: #imageLiteral(resourceName: "plugExample")  , member: memberHarvey))
        newPlugs?.append(Plug(id: 12565, description: "J'ai fait cette fiche de révision qui est une prise de note de mon cours de ce Poème", title: "Le brasier", photo: #imageLiteral(resourceName: "plugExample")  , member: memberHarvey))
        newPlugs?.append(Plug(id: 12565, description: "Ce plug est une prise de note de mn cours sur la bataille de verdun", title: "La bataille de verdun", photo: #imageLiteral(resourceName: "plugExample")  , member: memberHarvey))
    }
//    
//    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        let myView = TopNewsCell(frame: CGRect(x: 0, y: 0, width: screenSize.width * 1, height: heightOfNewsCell))
//        myView.randomBackgroundColor(number: index)
//        myView.label.text = plugeeNews[index]
//        return myView
//    }
//    
//    public func numberOfItems(in carousel: iCarousel) -> Int {
//        return plugeeNews.count
//    }
//    
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        if (option == .spacing){
//            return value * 1
//        }
//        return value
//    }
//    
//    /*------------------------------------ CONSTRAINT ---------------------------------------------*/
//  
    func setupMyView() {
        let topConstant: CGFloat = CGFloat((self.navigationController?.navigationBar.frame.height)!) + 40
        newsView.topAnchor.constraint(equalTo: self.view.topAnchor, constant : topConstant).isActive = true
        newsView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        newsView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newsView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        self.view.addSubview(myView)
        
        myView.topAnchor.constraint(equalTo: self.newsView.bottomAnchor, constant: 50).isActive = true
        myView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 4/5).isActive = true
        myView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    func setupNewPlugCarousel() {
    }

}
