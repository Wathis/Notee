//
//  TabBarController.swift
//  Notee
//
//  Created by Mathis Delaunay on 18/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = NewsController()
        controller.tabBarItem.image = #imageLiteral(resourceName: "IconeTabBar")
        var arrayViews : [UIViewController] = [createAViewController(controller: NewsController(), image: #imageLiteral(resourceName: "plane"))]
        arrayViews.append(createAViewController(controller: HomeController(), image: #imageLiteral(resourceName: "home")))
        arrayViews.append(createAViewController(controller: TopController(), image: #imageLiteral(resourceName: "podium")))
        
        viewControllers = arrayViews
        self.selectedIndex = 1
    }
    
    private func createAViewController(controller : UIViewController, image : UIImage) -> UINavigationController {
        let controller = controller
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.title = ""
        navController.tabBarItem.image = image
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        navController.tabBarItem.title = nil
        return navController
    }
}
