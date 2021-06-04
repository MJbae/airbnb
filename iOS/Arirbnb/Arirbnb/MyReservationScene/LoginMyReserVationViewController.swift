//
//  MyReserVationViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

class LoginMyReserVationViewController: UIViewController, ViewControllerIdentifierable, Alertable {

    static func create() -> LoginMyReserVationViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginMyReserVationViewController else {
            return LoginMyReserVationViewController()
        }
        return vc
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        userNameLabel.text = "\(LoginManager.shared.userName)님 어서오세요."
    }
    
    @IBAction func logoutButtonDidTap(_ sender: Any) {
//        showAlert(message: "로그아웃 되었습니다.") {
//            LoginManager.shared.logout()
//        }
        let alert = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            LoginManager.shared.logout()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
