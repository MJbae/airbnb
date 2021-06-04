//
//  LogoutWishListViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import UIKit

class LogoutWishListViewController: UIViewController, ViewControllerIdentifierable {
    
    static func create() -> LogoutWishListViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LogoutWishListViewController else {
            return LogoutWishListViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        let loginVC = LoginNavigationController()
        present(loginVC, animated: true, completion: nil)        
    }
}
