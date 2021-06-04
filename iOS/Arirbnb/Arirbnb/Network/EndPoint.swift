//
//  EndPoint.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import Foundation
import Alamofire

protocol Requestable {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var parameter: Parameters { get }
    var header: HTTPHeader? { get }
    var url: String { get }
}

extension Requestable {
}

struct EndPoint: Requestable {
    var baseUrl = "http://15.164.68.136/api/"
    var path: String
    var httpMethod: HTTPMethod
    var parameter: Parameters
    var header: HTTPHeader?
    var url: String {
        return baseUrl+path
    }
}
