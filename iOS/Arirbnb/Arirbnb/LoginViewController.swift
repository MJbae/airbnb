//
//  LoginViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import UIKit

class LoginViewController: UIViewController, ViewControllerIdentifierable {

    static func create() -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "로그인 또는 회원 가입"
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
