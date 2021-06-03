//
//  MyReserVationViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

class LoginMyReserVationViewController: UIViewController, ViewControllerIdentifierable {

    static func create() -> LoginMyReserVationViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginMyReserVationViewController else {
            return LoginMyReserVationViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
