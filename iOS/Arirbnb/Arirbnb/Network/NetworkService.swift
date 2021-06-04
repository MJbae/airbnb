//
//  NetworkService.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import Foundation
import Alamofire
//
//protocol NetworkService {
//    func request<T: Decodable>(with endpoint: Requestable, dataType: T.Type) -> AnyPublisher<T, NetworkError>
//    func decode<T: Decodable>(data: Data, dataType: T.Type) -> AnyPublisher<T, NetworkError>
//}

class NetworkService {
    static var shared = NetworkService()
    
    private init() {}
    
    func request<T>(with endpoint: Requestable, dataType: T.Type, completionHandler: @escaping (DataResponse<T, AFError>) -> Void) where T : Decodable {
        let url = endpoint.url
  
        AF.request(url, method: endpoint.httpMethod, parameters: endpoint.parameter, encoding: URLEncoding.queryString).responseDecodable { (response: DataResponse<T,AFError>) in
            completionHandler(response)
        }
    }
    
    func requestAccomodations(with endpoint: Requestable, completionHandler: @escaping (Result<[Accommodation],AFError>) -> Void) {
        let url = endpoint.url
  
        AF.request(url, method: endpoint.httpMethod, parameters: endpoint.parameter, encoding: URLEncoding.queryString).responseDecodable { (response: DataResponse<[Accommodation],AFError>) in
            let result = response.result
            completionHandler(result)
        }
    }
    
    func requestWishList(with endPoint: Requestable, completionHandler: @escaping (Result<[WishListItem],AFError>) -> Void) {
        guard let header = endPoint.header else { return }
        let headers = HTTPHeaders.init([header])
        AF.request(endPoint.url, method: endPoint.httpMethod, headers: headers).responseDecodable { (response: DataResponse<[WishListItem],AFError>) in
            let result = response.result
            completionHandler(result)
        }
    }
    
    func decode<T: Decodable>(data: Data, dataType: T.Type) -> Result<T, NetworkError>{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = try? decoder.decode(dataType, from: data) else {
            return .failure(.parsing(description: "parsing error"))
        }
        return .success(data)
    }
}

enum NetworkError: Error {
    case network(description: String)
    case parsing(description: String)
}

