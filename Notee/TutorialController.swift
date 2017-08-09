//
//  TutorialController.swift
//  Notee
//
//  Created by Mathis Delaunay on 08/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class TutorialController: UIPageViewController,UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
     lazy var controllers : [UIViewController] = [self.createViewController(backgroundImage : #imageLiteral(resourceName: "organize_appstore")),self.createViewController(backgroundImage: #imageLiteral(resourceName: "news_appstore")),self.createViewController(backgroundImage : #imageLiteral(resourceName: "tags_appstore")),self.createViewController(backgroundImage: #imageLiteral(resourceName: "comments_appstore"))]
    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.dataSource = self
        self.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = controllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else {
            return nil
        }
        if index - 1 >= 0 {
            return controllers[index - 1]
        } else {
            return nil
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else {
            return nil
        }
        if index + 1 < controllers.count {
            return controllers[index + 1]
        } else {
            if index + 1 == controllers.count {
                _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
                    self.present(TabBarController(), animated: true, completion: nil)
                })
            }
            return nil
        }
    }
    
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    
    func createViewController(backgroundImage: UIImage) -> UIViewController {
        let controller = UIViewController()
        let imageBackground = UIImageView()
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.image = backgroundImage
        controller.view.addSubview(imageBackground)
        NSLayoutConstraint.activate([
            imageBackground.widthAnchor.constraint(equalTo: controller.view.widthAnchor),
            imageBackground.heightAnchor.constraint(equalTo: controller.view.heightAnchor,constant: 0),
            imageBackground.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            imageBackground.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor, constant : 0)
            ])
        return controller
    }
    
    func  goTabBarController(){
        present(TabBarController(), animated: true, completion: nil)
    }
    
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
}
