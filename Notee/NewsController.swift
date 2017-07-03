//
//  NewsController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class NewsController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    
    let screenSize = UIScreen.main.bounds
    let heightOfNewsCell : CGFloat = 75
    var timerForNews = Timer()
    var noteeNews : [String] = []
    var myPlugs = [1,2,3,4]
    
    var plugs : [Plug] = []
    
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
        loadSheets()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profil"), style: .plain, target: self, action: #selector(handleProfil))
        setupMyViews()
        loadMessages()
    }
    
    func handleProfil() {
        
    }
    
    func loadMessages() {
        self.noteeNews.removeAll()
        let ref = Database.database().reference().child("newsMessage")
        ref.observe(.value, with: { (snapshot) in
            guard let messages = snapshot.value as? NSDictionary else {
                return
            }
            self.noteeNews.removeAll()
            for message in messages {
                guard let messageText = message.value as? String else {
                    return
                }
                self.noteeNews.append(messageText)
            }
            self.loadMyViewsForNewsScrollView()
        })
    }
    
    func handleRefresh() {
        loadMessages()
        loadSheets()
    }
    
    func loadSheets() {
        self.plugs.removeAll()
        self.newPlugCarousel.reloadData()
        let ref = Database.database().reference().child("sheets").queryLimited(toFirst: 20)
        ref.observe(.value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {
                return
            }
            for value in values {
                if let keyPlug = value.key as? String, let informationOfSheet = value.value as? NSDictionary  {
                    guard let description = informationOfSheet["description"] as? String,let discipline = informationOfSheet["discipline"] as? String , let title = informationOfSheet["title"] as? String, let theme = informationOfSheet["theme"] as? String ,let memberUID = informationOfSheet["memberUID"] as? String, let url = informationOfSheet["urlDownlaod"] as? String else {
                        return
                    }
                    self.plugs.append(Plug(id: keyPlug, discipline: discipline, description: description, theme: theme, title: title, member: Member(id: memberUID), urlPhoto :url ))
                }
            }
            self.plugs.reverse()
            self.newPlugCarousel.reloadData()
        })
    }
    
    func setupScrollView() {
        self.newsOfPlugScrollView.removeFromSuperview()
        self.view.addSubview(newsOfPlugScrollView)
        
        heightOfNavBar = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        newsOfPlugScrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant : 20).isActive = true
        newsOfPlugScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        newsOfPlugScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        newsOfPlugScrollView.heightAnchor.constraint(equalToConstant: heightOfNewsCell).isActive = true
    }
    
    func setupMyViews() {
        
        setupScrollView()
        
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
        return plugs.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let heightOfNewPlug = (self.view.frame.height) - heightOfNavBar! - heightOfTabBar! - heightOfNewsCell
        let view = newPlugView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 8 / 10, height: heightOfNewPlug))
        view.descriptionText = plugs[index].description
        view.titleOfNewPlug.text = plugs[index].title
        view.themeText = plugs[index].theme
        view.disciplineText = plugs[index].discipline
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
        setupScrollView()
        var iSave: CGFloat = 0;
        for i in 0 ..< noteeNews.count {
            let view = TopNewsCell(frame: CGRect(x: screenSize.width * CGFloat(i), y: 0, width: screenSize.width, height: heightOfNewsCell))
            newsOfPlugScrollView.addSubview(view)
            view.label.text = noteeNews[i]
            view.randomBackgroundColor(number: i)
            iSave = CGFloat(i + 1);
        }
        self.newsOfPlugScrollView.contentSize = CGSize(width: screenSize.width * iSave, height: heightOfNewsCell)
        
    }
    
    
}
