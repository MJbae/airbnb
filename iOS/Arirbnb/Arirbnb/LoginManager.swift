//
//  LoginManager.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/29.
//

import Foundation

import Alamofire
import KeychainSwift

class LoginManager {
    
    struct JWT: Decodable {
        let jwt: String
    }
    
    static let shared = LoginManager()
    
    private init() {}
    
    private let keychain = KeychainSwift()
    private let callbackUrlScheme = "airbnb"
    private let clientID = "34a66f51f68864c9adfd"
    private let redirectURI = "airbnb://login"
    private var jwt = ""
    
    func requestCode(handler: @escaping (URL, String)->()) {
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=user")
        handler(url!, callbackUrlScheme)
    }
    
    func requestJWT(with code: URL) {
        let code = abstractCode(with: code)
        let url = "http://15.165.76.167:8080/api/login/auth?client=ios&code=\(code)"
        print(url)
        AF.request(url, method: .get).validate().responseData { data in
            print(data)
            guard let data = data.data else { return }
            guard let jwt = try? JSONDecoder().decode(JWT.self, from: data) else { return }
            self.jwt = jwt.jwt
            print(jwt)
        }
    }
    
    func isLoging() -> Bool {
        return false
    }
    private func abstractCode(with url: URL) -> String {
        if url.absoluteString.starts(with: "airbnb://") {
            if let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) {
                print(code)
                return code
            }
        }
        return ""
    }
}
