//
//  NewsController.swift
//  Plugee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit


class NewsController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    
    let screenSize = UIScreen.main.bounds
    let heightOfNewsCell : CGFloat = 75
    var timerForNews = Timer()
    var plugeeNews = ["Plugee permet de partager vos fiches de révision !","Ajoutez à vos favoris les fiches de vos amis !"
        ,"Pourquoi ne pas invitez vos amis a rejoindre Plugee ?","Vous ne savez pas comment utiliser Plugee ? Cliquez ici !"]
    var myPlugs = [1,2,3,4]
    
    var heightOfNavBar : CGFloat?
    var heightOfTabBar : CGFloat?
    
    lazy var newsOfPlugScrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
        sv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.heightOfNewsCell)
        sv.backgroundColor = .gray
        sv.layer.shadowColor = UIColor.black.cgColor
        sv.layer.shadowOffset = CGSize(width: -1, height: 1)
        sv.layer.shadowOpacity = 0.2
        sv.layer.shadowRadius = 2
        sv.layer.masksToBounds = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    lazy var newPlugCarousel : iCarousel = {
        let carousel = iCarousel()
        carousel.delegate = self
        carousel.dataSource = self
        carousel.isPagingEnabled = true
        carousel.type = .linear
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "News"
        //Important for the scrollView
        self.automaticallyAdjustsScrollViewInsets = false
        setupMyViews()
        loadMyViewsForNewsScrollView()
    }
    func setupMyViews() {
        self.view.addSubview(newsOfPlugScrollView)
        
        heightOfNavBar = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        newsOfPlugScrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant : 20).isActive = true
        newsOfPlugScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        newsOfPlugScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        newsOfPlugScrollView.heightAnchor.constraint(equalToConstant: heightOfNewsCell).isActive = true
        
        self.view.addSubview(newPlugCarousel)
        
        newPlugCarousel.topAnchor.constraint(equalTo: newsOfPlugScrollView.bottomAnchor, constant: 13).isActive = true
        newPlugCarousel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newPlugCarousel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        heightOfTabBar = CGFloat((self.tabBarController?.tabBar.frame.height)!) + 10
        newPlugCarousel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightOfTabBar!).isActive = true
    }
    
    func handleReport(myPlug : newPlugView) {
        let navigationController = UINavigationController(rootViewController: ReportController())
        present(navigationController, animated: true, completion: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let heightOfNewPlug = (self.view.frame.height) - heightOfNavBar! - heightOfTabBar! - heightOfNewsCell
        let view = newPlugView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 8 / 10, height: heightOfNewPlug))
        view.buttonReport.addTarget(self, action: #selector(handleReport), for: .touchUpInside)
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func loadMyViewsForNewsScrollView() {
        var iSave: CGFloat = 0;
        for i in 0 ..< plugeeNews.count {
            let view = TopNewsCell(frame: CGRect(x: screenSize.width * CGFloat(i), y: 0, width: screenSize.width, height: heightOfNewsCell))
            newsOfPlugScrollView.addSubview(view)
            view.label.text = plugeeNews[i]
            view.randomBackgroundColor(number: i)
            iSave = CGFloat(i + 1);
        }
        self.newsOfPlugScrollView.contentSize = CGSize(width: screenSize.width * iSave, height: heightOfNewsCell)
        
    }
    
    
}
