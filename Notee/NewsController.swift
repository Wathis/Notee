//
//  NewsController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class NewsController: UIViewController, UIScrollViewDelegate, iCarouselDataSource, iCarouselDelegate, DelegateAlertViewer {

    
    let screenSize = UIScreen.main.bounds
    let heightOfNewsCell : CGFloat = 75
    var timerForNews = Timer()
    var noteeNews : [String] = []
    var myPlugs = [1,2,3,4]
    let timeBeforeSwitchNews : TimeInterval = 7
    
    var heightOfNewPlug : CGFloat = 0
    var keywords : [String] = []
    
    
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
        sv.delegate = self
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
    
    let messsageInformationNoNews = InformationMessage(information: "Pas de nouvelle fiche")
    
    var observorMessageFromNotee : ObservorNoteeMessage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.navigationItem.title = "News"
        //Important for the scrollView
        self.automaticallyAdjustsScrollViewInsets = false
        observorMessageFromNotee = ObservorNoteeMessage(parent: self)
        observorMessageFromNotee.beginObserve()
        self.navigationItem.leftBarButtonItems = [ UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(handleRefresh)), UIBarButtonItem(image: #imageLiteral(resourceName: "key"), style: .plain, target: self, action: #selector(handleKeywords))]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profil"), style: .plain, target: self, action: #selector(handleProfil))
        setupMyViews()
        timerForPagging = Timer.scheduledTimer(timeInterval: self.timeBeforeSwitchNews, target: self, selector: #selector(nextMessage), userInfo: nil, repeats: false)
    }
    
     let KEY_OF_SWITCH_NEWS = "enableNewsInfo"
    
    override func viewWillAppear(_ animated: Bool) {
        loadTags()
        loadMessages()
        loadCoins()
        loadSheets()
        loadSettings()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        loadUser()
    }
    
    var memberConnected : Member!
    
    func loadUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("members/\(uid)")
        ref.observe(.value ,with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {return}
            guard let pseudo = values["pseudo"] as? String, let urlImage = values["imageUrl"] as? String else {return}
            self.memberConnected = Member(id: uid, pseudo: pseudo, urlImage : urlImage)
            if (urlImage != ""){
                guard let checkedUrl = URL(string: urlImage) else {
                    return
                }
                let download = DownloadFromUrl()
                download.downloadImage(url: checkedUrl, completion: { (image) in
                    self.memberConnected.profilImage = image
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                })
            } else {
                self.memberConnected.profilImage = #imageLiteral(resourceName: "defaultProfilImage")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
    }
    
    func loadSettings() {
        guard let enableNews = UserDefaults.standard.value(forKey: KEY_OF_SWITCH_NEWS) as? Bool else {return}
        if (enableNews) {
            newsOfPlugScrollView.isHidden = false
            constraintTopNewsPlugCarousel.constant = 20 + heightOfNewsCell
            heightOfNewPlug = (self.view.frame.height) - heightOfNavBar! - heightOfTabBar! - heightOfNewsCell
            
        } else {
            newsOfPlugScrollView.isHidden = true
            constraintTopNewsPlugCarousel.constant = 0
            heightOfNewPlug = (self.view.frame.height) - heightOfNavBar! - heightOfTabBar!
        }
        newPlugCarousel.updateConstraints()
    }
    
    func handleKeywords() {
        let controller = TagsViewController(collectionViewLayout: UICollectionViewLayout())
        controller.keywords = self.keywords
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func handleProfil() {
        let controller = ProfilController()
        controller.memberConnected = memberConnected
        controller.noteeCoinsIndicator.noteeCoins = self.noteeCoinsAvailables
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.newsOfPlugScrollView {
            self.timerForPagging?.invalidate()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.newsOfPlugScrollView {
            let indexOfScroll = Int(scrollView.contentOffset.x / self.view.frame.width)
            self.iteratorForPagging = indexOfScroll
            self.timerForPagging = Timer.scheduledTimer(timeInterval: timeBeforeSwitchNews, target: self, selector: #selector(nextMessage), userInfo: nil, repeats: false)
        }
    }
    
    func loadTags() {
        self.keywords.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("members/\(uid)/tags").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {return}
            for val in values {
                if let word = val.key as? String {
                    self.keywords.append(word.lowercased())
                }
            }
        })
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
    
    func sortSheets() {
        plugs = plugs.sorted(by: {$0.date!.timeIntervalSinceNow < $1.date!.timeIntervalSinceNow})
    }
    
    func enableNavigationButtons(_ enable : Bool){
        guard let buttonsLeft = navigationItem.leftBarButtonItems else {return}
        for button in buttonsLeft {
            button.isEnabled = enable
        }
    }
    
    func loadSheets() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.plugs.removeAll()
        enableNavigationButtons(false)
        self.newPlugCarousel.reloadData()
        let ref = Database.database().reference().child("sheets").queryLimited(toFirst: 100)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.hasChildren() {
                self.finishLoad()
            }
        })
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary else {
                return
            }
            for value in values {
                if let keyPlug = value.key as? String, let informationOfSheet = value.value as? NSDictionary  {
                    guard let description = informationOfSheet["description"] as? String,let discipline = informationOfSheet["discipline"] as? String , let title = informationOfSheet["title"] as? String, let theme = informationOfSheet["theme"] as? String ,let memberUID = informationOfSheet["memberUID"] as? String, let url = informationOfSheet["urlDownload"] as? String, let starsCount = informationOfSheet["starsCount"] as? String, let interval = informationOfSheet["date"] as? String, let pseudo = informationOfSheet["pseudo"] as? String, let tagsDictionnary = informationOfSheet["tags"] as? [String:Bool] else {
                        return
                    }
                    var tags : [String] = []
                    for tag in tagsDictionnary {
                        tags.append(tag.key)
                    }
                    let date = NSDate(timeIntervalSince1970: Double(interval)!)
                    let plugToAdd = Plug(id: keyPlug, discipline: discipline, description: description, theme: theme, title: title, member: Member(id: memberUID, pseudo: pseudo), urlPhoto :url, starsCount : Int(starsCount)!, date: date, tags :tags)
                    self.plugs.append(plugToAdd)
                    let refOfSheet = Database.database().reference().child("sheets/\(keyPlug)/members")
                    refOfSheet.observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let members = snapshot.value as? NSDictionary else {
                            self.finishLoad()
                            return
                        }
                        guard let _ = members[uid] as? Bool else {
                            self.finishLoad()
                            return
                        }
                        let index = self.findIndexOfSheet(plugToAdd)
                        if index != -1 {
                            self.plugs[index].isAdded = true
                            self.finishLoad()
                        }
                    })
                }
            }
        })
    }
    
    func removeSheet(sheet : Plug){
        var i  = 0
        for plug in plugs {
            if plug.id == sheet.id {
                self.plugs.remove(at: i)
            }
            i = i + 1
        }
    }
    
    func finishLoad() {
        self.messsageInformationNoNews.isHidden = true
        var numberOfKeywords = 0
        for sheet in self.plugs {
            guard let tags = sheet.tags else {return}
            for tag in tags {
                if keywords.contains(tag) {
                    numberOfKeywords += 1
                }
            }
            if numberOfKeywords == 0 {
                removeSheet(sheet: sheet)
            }
            numberOfKeywords = 0
        }
        if self.plugs.count == 0 {
            appearMessageInformation("Pas de nouvelles fiches")
        }
        self.sortSheets()
        self.plugs.reverse()
        enableNavigationButtons(true)
        self.newPlugCarousel.reloadData()
    }
    
    func appearMessageInformation(_ information : String) {
        messsageInformationNoNews.message = information
        messsageInformationNoNews.isHidden = false
    }
    
    func findIndexOfSheet(_ sheetToFind : Plug) -> Int {
        var i = 0
        for sheet in plugs {
            if sheet.id == sheetToFind.id {
                return i
            }
            i += 1
        }
        return -1
    }
    
    func addNewSheet(_ sender : ButtonAddSheet) {
        
        guard let sheet = sender.sheet, let uid = Auth.auth().currentUser?.uid, let idOfSheet = sheet.id else {return}
        if (sheet.isAdded == false){
            sender.userClicked()
            sender.sheet?.isAdded = true
            sender.changeColorOfButton()
            let membersDisciplineValue = [sheet.discipline : true ]
            let membersThemesValue = [sheet.theme : true]
            let themeSheetValue = [String(describing: idOfSheet) : true]
            let sheetValue = [uid : true]
            let refMembersDiscipline = Database.database().reference().child("members-discipline/\(uid)")
            var refMembersTheme = Database.database().reference().child("members-themes/\(uid)/\(sheet.discipline)").childByAutoId()
            let keyOfTheme = refMembersTheme.key
            var refThemeSheets = Database.database().reference().child("theme-sheets/\(keyOfTheme)")
            let refSheet = Database.database().reference().child("sheets/\(String(describing: idOfSheet))/members")
            //Check if theme already exists
            Database.database().reference().child("members-themes/\(uid)/\(sheet.discipline)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let values = snapshot.value as? NSDictionary {
                    for value in values {
                        guard let themeKey = value.key as? String, let themeDictionary = value.value as? NSDictionary else {return}
                        if let _ = themeDictionary[sheet.theme]  {
                            refMembersTheme = Database.database().reference().child("members-themes/\(uid)/\(sheet.discipline)/\(themeKey)")
                            refThemeSheets = Database.database().reference().child("theme-sheets/\(themeKey)")
                            break
                        }
                    }
                }

                refMembersDiscipline.updateChildValues(membersDisciplineValue , withCompletionBlock: { (error, databaseReference) in
                    if error != nil {
                        return
                    }
                    refMembersTheme.updateChildValues(membersThemesValue, withCompletionBlock: { (error, dataReference) in
                        if error != nil {
                            return
                        }
                        refThemeSheets.updateChildValues(themeSheetValue, withCompletionBlock: { (error, dataReference) in
                            if error != nil {
                                return
                            }
                            refSheet.updateChildValues(sheetValue, withCompletionBlock: { (error, dataReference) in
                                if error != nil {
                                    return
                                }
                            })
                        })
                    })
                })
                
            })
        }
    }
    
    func setupScrollView() {
        self.view.addSubview(newsOfPlugScrollView)
        
        heightOfNavBar = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        newsOfPlugScrollView.topAnchor.constraint(equalTo: self.view.topAnchor,constant : 20).isActive = true
        newsOfPlugScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        newsOfPlugScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        newsOfPlugScrollView.heightAnchor.constraint(equalToConstant: heightOfNewsCell).isActive = true
    }
    
    var constraintTopNewsPlugCarousel : NSLayoutConstraint!
    
    func setupMyViews() {
        
        setupScrollView()
        
        self.view.addSubview(newPlugCarousel)
        constraintTopNewsPlugCarousel = newPlugCarousel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20 + heightOfNewsCell)
        constraintTopNewsPlugCarousel.isActive = true
        newPlugCarousel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newPlugCarousel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        heightOfTabBar = CGFloat((self.tabBarController?.tabBar.frame.height)!) + 10
        newPlugCarousel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightOfTabBar!).isActive = true
        
        messsageInformationNoNews.isHidden = true
        
        self.view.addSubview(messsageInformationNoNews)
        NSLayoutConstraint.activate([
            messsageInformationNoNews.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            messsageInformationNoNews.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            messsageInformationNoNews.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            messsageInformationNoNews.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func handleReport(_ sender : ButtonAddSheet) {
        let navigationController = UINavigationController(rootViewController: ReportController())
        sender.userClicked()
        present(navigationController, animated: true, completion: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return plugs.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = newPlugView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 8 / 10, height: heightOfNewPlug))
        view.descriptionText = plugs[index].description
        view.sheet = plugs[index]
        view.isUserInteractionEnabled = true
        if let title = plugs[index].member?.pseudo, let datePosted = plugs[index].date {
            view.titleOfNewPlug.text = "\(title) " + NSDate().getTimeFrom(date: datePosted)
        }
        view.themeText = plugs[index].theme
        view.titleText = plugs[index].title
        view.buttonAdd.changeColorOfButton()
        if plugs[index].starsCount != nil {
            view.numberOfFavoriteLabel.text = String(describing: plugs[index].starsCount!)
        }
        view.disciplineText = plugs[index].discipline
        view.buttonReport.addTarget(self, action: #selector(handleReport(_:)), for: .touchUpInside)
        view.buttonAdd.addTarget(self, action: #selector(addNewSheet(_:)), for: .touchUpInside)
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let controller = PlugAlertModalView()
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self
        controller.currentPlug = plugs[index]
        controller.noteeCoinsAvailables = noteeCoinsAvailables
        self.present(controller, animated: false, completion: {
            controller.addTargetForPlugViewer()
        })
    }
    
    var noteeCoinsAvailables : Int = 0
    
    func loadCoins() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let refMember = Database.database().reference().child("members/\(uid)")
        
        refMember.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let values = snapshot.value as? NSDictionary, let noteeCoins = values["noteeCoins"] as? Int else {return}
            self.noteeCoinsAvailables = noteeCoins
        })
    }
    
    func presentViewer(plug: Plug) {
        let controller = viewerController()
        controller.plug = plug
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    var timerForPagging : Timer?
    
    func loadMyViewsForNewsScrollView() {
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
    var iteratorForPagging = 1
    
    func nextMessage() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
            if self.newsOfPlugScrollView.contentOffset.x < self.screenSize.width * CGFloat(self.iteratorForPagging) {
                self.newsOfPlugScrollView.contentOffset = CGPoint(x: self.newsOfPlugScrollView.contentOffset.x + 1, y: 0)
            } else {
                timer.invalidate()
                if (self.iteratorForPagging < self.noteeNews.count - 1) {
                    self.iteratorForPagging += 1
                    timer.invalidate()
                    self.timerForPagging = Timer.scheduledTimer(timeInterval: self.timeBeforeSwitchNews, target: self, selector: #selector(self.nextMessage), userInfo: nil, repeats: false)
                } else {
                    self.iteratorForPagging = 1
                    _ = Timer.scheduledTimer(withTimeInterval: self.timeBeforeSwitchNews, repeats: false, block: { (timer) in
                        _ = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: { (timer) in
                            if self.newsOfPlugScrollView.contentOffset.x > 0 {
                                self.newsOfPlugScrollView.contentOffset = CGPoint(x: self.newsOfPlugScrollView.contentOffset.x - 1, y: 0)
                            } else {
                                timer.invalidate()
                                self.timerForPagging = Timer.scheduledTimer(timeInterval: self.timeBeforeSwitchNews, target: self, selector: #selector(self.nextMessage), userInfo: nil, repeats: false)
                            }
                        })
                    })
                }
            }
        })
    }
    
}
