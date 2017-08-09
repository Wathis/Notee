//
//  ShopViewController.swift
//  Notee
//
//  Created by Mathis Delaunay on 06/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase
import StoreKit
import GoogleMobileAds

class ProductNoteeCoins  {
    
    var price : String!
    var noteeCoins : String!
    var appleId : String!
    
    init(appleId : String, price : String, noteeCoins : String) {
        self.appleId = appleId
        self.price = price
        self.noteeCoins = noteeCoins
    }
    
}

class ShopController: UICollectionViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate,GADRewardBasedVideoAdDelegate {

    var enableButtons : Bool! {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    var request = GADRequest()
    
    let reuseIdentifier = "cellId"
    let productValues : [ProductNoteeCoins] = [
        ProductNoteeCoins(appleId: "com.wathis.notee.100coins", price: "2.29", noteeCoins: "100"),
        ProductNoteeCoins(appleId: "com.wathis.notee.350coins", price: "5.49", noteeCoins: "350"),
        ProductNoteeCoins(appleId: "com.wathis.notee.1000coins", price: "10.99", noteeCoins: "1000"),
        ProductNoteeCoins(appleId: "com.wathis.notee.2500coins", price: "21.99", noteeCoins: "2500"),
        ProductNoteeCoins(appleId: "com.wathis.notee.6000coins", price: "54.99", noteeCoins: "6000"),
        ProductNoteeCoins(appleId: "", price: "free", noteeCoins: "10")
    ]
    
    let unitIDAdMob = "ca-app-pub-7224152034759039/2170321599"
    let unitIDAdMobTest  = "ca-app-pub-3940256099942544/1712485313"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Boutique"
        self.collectionView?.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.collectionView!.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        enableButtons = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom:10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 100)
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "question"), style: .plain, target: self, action: #selector(handleQuestion))
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        
        loadAdMod()
        
        if (SKPaymentQueue.canMakePayments()) {
            let productID: NSSet = NSSet(objects: "com.wathis.notee.100coins", "com.wathis.notee.350coins","com.wathis.notee.1000coins","com.wathis.notee.2500coins","com.wathis.notee.6000coins")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("InAppPurchase are not availables")
        }
        
    }
    
    func handleQuestion() {
        let alert = PlugAlertModalView(title: "Obtenir des Notee Coins", description: "- En partageant des fiches de révisions (10 Notee Coins) \n- En recevant des étoiles sur vos fiches de révisions (1 par étoile)")
        present(alert, animated: false, completion: nil)
    }
    
    var rewardUser = false
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        rewardUser = true
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        if rewardUser {
            addNoteeCoins(10)
            rewardUser = false
        }
        loadAdMod()
    }
    
    func loadAdMod() {
        request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().load(request,
                                                    withAdUnitID: unitIDAdMobTest)
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProduct = response.products
        for product in myProduct {
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            list.append(product)
        }
        enableButtons = true
    }

    func buyProduct() {
        print("achat de " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func addNoteeCoins(_ number : Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("members/\(uid)/")
        ref.observeSingleEvent(of: .value, with: { (snap) in
            guard let value = snap.value as? NSDictionary,let coins = value["noteeCoins"] as? Int else {return}
            ref.updateChildValues(["noteeCoins" : coins + number])
            
            ref.updateChildValues(["noteeCoins" : coins + number], withCompletionBlock: { (eroor, refData) in
                let alert = PlugAlertModalView(title: "Félicitations", description: "Votre compte à bien été rechargé de \(number) Notee Coins")
                self.present(alert, animated: true, completion: nil)
            })
            
        })
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
            case .purchased:
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                case "com.wathis.notee.100coins":
                    addNoteeCoins(100)
                case "com.wathis.notee.350coins":
                    addNoteeCoins(350)
                case "com.wathis.notee.1000coins":
                    addNoteeCoins(1000)
                case "com.wathis.notee.2500coins":
                    addNoteeCoins(2500)
                case "com.wathis.notee.6000coins":
                    addNoteeCoins(6000)
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                print(trans.error ?? "erreur")
                queue.finishTransaction(trans)
                break
            default:
                
                break
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productValues.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        cell.price = productValues[indexPath.row].price == "free" ? "Gratuit" : productValues[indexPath.row].price + " €"
        cell.noteeCoins = productValues[indexPath.row].noteeCoins
        cell.isEnable = self.enableButtons
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if enableButtons {
            
            if productValues[indexPath.row].price == "free" {
                print(GADRewardBasedVideoAd.sharedInstance().isReady)
                if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                    GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                } else {
                    let alert = PlugAlertModalView(title: "Service indisponible", description: "Veuillez réessayer plus tard")
                    self.present(alert, animated: true, completion: nil)
                    loadAdMod()
                }
                return
            }
            
            for product in list {
                let prodID = product.productIdentifier
                if(prodID == productValues[indexPath.row].appleId) {
                    p = product
                    let pay = SKPayment(product: p)
                    SKPaymentQueue.default().add(self)
                    SKPaymentQueue.default().add(pay as SKPayment)
                }
            }
        }
    }
    
}
