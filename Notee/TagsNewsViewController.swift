//
//  KeywordsViewController.swift
//  Notee
//
//  Created by Mathis Delaunay on 04/08/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import Firebase



class TagsViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    
    /*------------------------------------ VARIABLES ----------------------------------------------*/
    
     var keywords : [String] = []
    
    /*------------------------------------ CONSTANTS ----------------------------------------------*/
    
    private let ID_CELL_KEYWORD = "cellId"
    private let ID_FOOTER_KEYWORK = "cellFooterId"
    
    /*------------------------------------ CONSTRUCTORS -------------------------------------------*/
    /*------------------------------------ VIEW DID SOMETHING -------------------------------------*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = "Tags"
        self.collectionView?.backgroundColor = UIColor(r: 227, g: 228, b: 231)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom:5, right: 15)
        layout.footerReferenceSize = CGSize(width: 80, height: 40)
        layout.itemSize = CGSize(width: 80, height: 40)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
        
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.register(TagsCell.self, forCellWithReuseIdentifier: ID_CELL_KEYWORD)
        self.collectionView?.register(FooterTagsTextField.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ID_FOOTER_KEYWORK)
    }
    
    /*------------------------------------ FUNCTIONS DELEGATE -------------------------------------*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let word = textField.text else {return false}
        textField.text = ""
        if word.characters.count > 0 {
            addNewKeyword(word)
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let number = Int(string)
        if number != nil {
            return false
        } else {
            return true
        }
    }
    
    func textFieldChange(_ sender: UITextField) {
        guard var text = sender.text else {return}
        if (text.characters.count > 20) {
            _ = sender.text?.characters.popLast()
        }
        let last = text.characters.popLast()
        if (text.contains(" ")){
            sender.text = ""
        } else {
            if (last == " " && text.characters.count > 0 && !keywords.contains(text)){
                sender.text = ""
                addNewKeyword(text)
            }
        }
    }
    
    /*------------------------------------ FUNCTIONS DATASOURCE -----------------------------------*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = keywords[indexPath.row].width(withConstraintedHeight: 40, font: UIFont(name: "HelveticaNeue-Light", size: 15)!)
        return CGSize(width: width + 50, height: 40)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view : UICollectionReusableView!
        if (kind == UICollectionElementKindSectionFooter) {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ID_FOOTER_KEYWORK, for: indexPath) as! FooterTagsTextField
            footer.textField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
            footer.textField.delegate = self
            footer.textField.becomeFirstResponder()
            view = footer
        }
        return view
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID_CELL_KEYWORD, for: indexPath) as! TagsCell
        cell.deleteButton.tag = indexPath.row
        cell.label.text = keywords[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return cell
    }
    
    /*------------------------------------ BACK-END FUNCTIONS -------------------------------------*/
    
    func addNewKeyword(_ keyword : String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        keywords.append(keyword)
        collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [IndexPath(row: self.keywords.count - 1, section: 0)])
        }, completion: { (finish) in
            if (finish) {
                Database.database().reference().child("members/\(uid)/tags").updateChildValues([keyword.lowercased(): true])
            }
        })
    }
    
    /*------------------------------------ HANDLE FUNCTIONS ---------------------------------------*/
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleDelete(_ sender: UIButton) {
        let word = keywords.remove(at: sender.tag)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [IndexPath(row: sender.tag, section: 0)])
        }, completion: { (finish) in
            self.collectionView?.reloadData()
            if (finish) {
                Database.database().reference().child("members/\(uid)/tags/\(word.lowercased())").removeValue()
            }
        })
    }
    
    /*------------------------------------ FRONT-END FUNCTIONS ------------------------------------*/
    /*------------------------------------ CONSTRAINTS --------------------------------------------*/
    
    
}
