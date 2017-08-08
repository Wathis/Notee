//
//  AppDelegate.swift
//  Notee
//
//  Created by Mathis Delaunay on 12/03/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appIdApplication = "ca-app-pub-7224152034759039~7467892060"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let pageControl: UIPageControl = UIPageControl.appearance(whenContainedInInstancesOf: [TutorialController.self])
        pageControl.pageIndicatorTintColor = UIColor(r: 86, g: 90, b: 98)
        pageControl.currentPageIndicatorTintColor =  UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: appIdApplication)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = UIColor(r: 86, g: 90, b: 98)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20) as Any]
        //GENERAL SETUPS 
        //Mettre   -->   View controller-based status bar appearance      a   NO
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor(red: 98 / 255, green: 216 / 255, blue: 201 / 255, alpha: 1)
        
        //Modify KeyBoard color 
        UITextField.appearance().keyboardAppearance = .dark
        
        guard let _ = Auth.auth().currentUser?.uid else {
            window?.rootViewController = ConnectionController()
            return true
        }
        window?.rootViewController = TabBarController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

