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

class ShopController: UICollectionViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    var enableButtons : Bool! {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    let reuseIdentifier = "cellId"
    let productValues : [ProductNoteeCoins] = [
        ProductNoteeCoins(appleId: "com.wathis.notee.100coins", price: "2.29", noteeCoins: "100"),
        ProductNoteeCoins(appleId: "com.wathis.notee.350coins", price: "5.49", noteeCoins: "350"),
        ProductNoteeCoins(appleId: "com.wathis.notee.1000coins", price: "10.99", noteeCoins: "1000"),
        ProductNoteeCoins(appleId: "com.wathis.notee.2500coins", price: "21.99", noteeCoins: "2500"),
        ProductNoteeCoins(appleId: "com.wathis.notee.6000coins", price: "54.99", noteeCoins: "6000"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Boutique"
        self.collectionView?.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        self.collectionView!.register(ShopCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom:10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 100)
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        
        if (SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "com.wathis.notee.100coins", "com.wathis.notee.350coins","com.wathis.notee.1000coins","com.wathis.notee.2500coins","com.wathis.notee.6000coins")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("Vous devez autoriser les achats in apps")
        }
        
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        print("here")
    }
    
    @IBAction func btnAddCoins(_ sender: Any) {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "seemu.iap.addcoins") {
                p = product
                buyProduct()
            }
        }
    }
    func buyProduct() {
        print("buy " + p.productIdentifier)
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
                let alert = PlugAlertModalView()
                alert.titleOfAlert = "Félicitations"
                alert.titleCancelButton = "Retour"
                alert.descriptionOfAlert = "Votre compte à bien été rechargé de \(number) Notee Coins"
                self.present(alert, animated: true, completion: {
                    alert.titleConfirmationButton = "D'accord"
                })
            })
            
        })
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
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
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productValues.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        cell.price = productValues[indexPath.row].price
        cell.noteeCoins = productValues[indexPath.row].noteeCoins
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
