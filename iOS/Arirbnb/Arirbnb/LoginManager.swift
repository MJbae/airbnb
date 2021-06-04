//
//  LoginManager.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/29.
//

import Foundation

import Alamofire
import JWTDecode
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
    
    var jwt: String {
        return keychain.get("jwt") ?? ""
    }
    
    var userName: String {
        let userName = try? decode(jwt: keychain.get("jwt") ?? "").body["name"] as? String
        return userName ?? ""
    }
    
    func requestCode(handler: @escaping (URL, String)->()) {
        let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=user")
        handler(url!, callbackUrlScheme)
    }
    
    func requestJWT(with code: URL, completionHander: @escaping (Result<JWT,AFError>)->Void) {
        let code = abstractCode(with: code)
        print(code)
        let url = "http://15.164.68.136:80/api/login/auth?client=ios&code=\(code)"
        AF.request(url, method: .get).responseDecodable { (response: DataResponse<JWT, AFError>) in
            let result = response.result
            switch result {
            case .success(let jwt):
                self.saveJWT(jwt.jwt)
                NotificationCenter.default.post(name: .userIsLogin, object: self)
                completionHander(.success(jwt))
            case .failure(let error):
                completionHander(.failure(error))
            }
        }
    }

    func isLoging() -> Bool {
        guard keychain.get("jwt") != nil else { return false }
        return true
    }
        
    func saveJWT(_ jwt: String) {
        keychain.set(jwt, forKey: "jwt")
    }
    
    func logout() {
        NotificationCenter.default.post(name: .userIsLogout, object: self)
        keychain.clear()
    }
    
    private func abstractCode(with url: URL) -> String {
        if url.absoluteString.starts(with: "airbnb://") {
            if let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) {
                return code
            }
        }
        return ""
    }
}
