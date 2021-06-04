//
//  LogoutMyReserVationViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import UIKit

class LogoutMyReserVationViewController: UIViewController, ViewControllerIdentifierable {

    static func create() -> LogoutMyReserVationViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LogoutMyReserVationViewController else {
            return LogoutMyReserVationViewController()
        }
        return vc
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        let loginVC = LoginNavigationController()
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
