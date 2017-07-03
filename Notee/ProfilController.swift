//
//  ProfilController.swift
//  Notee
//
//  Created by Mathis Delaunay on 03/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit

class ProfilController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleBack))
    }

    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}
