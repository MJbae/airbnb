//
//  LoginViewController.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding, Alertable, ViewControllerIdentifierable {

    static func create() -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        return vc
    }
    
    private var webAuthSession: ASWebAuthenticationSession?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "로그인 또는 회원 가입"
        configureBackButton()
        configureWebAuthSession()
    }
    
    private func configureWebAuthSession() {
        LoginManager.shared.requestCode { url, callBackUrlScheme in
            self.webAuthSession = ASWebAuthenticationSession.init(url: url, callbackURLScheme: callBackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
                guard error == nil, let successURL = callBack else {
                    self.showAlert(message: "로그인에 실패했습니다.")
                    return
                }
                LoginManager.shared.requestJWT(with: successURL) { result in
                    switch result {
                    case .success(_):
                        self.showAlertWithDimiss(message: "로그인 성공했습니다.")
                    case .failure(_):
                        self.showAlert(message: "로그인에 실패했습니다. 다시 시도해주세요.")
                    }
                }
            })
        }
        webAuthSession?.presentationContextProvider = self
    }
    
    private func configureBackButton() {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: UIBarButtonItem.Style.done, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController {
    @IBAction func githubLoginButtonDidTap(_ sender: Any) {
        webAuthSession?.start()
    }
}
