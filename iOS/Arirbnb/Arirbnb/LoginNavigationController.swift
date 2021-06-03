//
//  LoginNavigationController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import UIKit

class LoginNavigationController: UINavigationController {

    convenience init() {
        let loginVC = LoginViewController.create()
        self.init(rootViewController: loginVC)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
