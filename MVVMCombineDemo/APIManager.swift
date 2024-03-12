//
//  APIManager.swift
//  MVVMCombineDemo
//
//  Created by Vicky Prajapati on 07/03/24.
//

import Foundation
import Alamofire
import Combine

enum APIError: Error {
    case noInternetConnection
    case unauthorized
    case invalidPath
    case failureError(Error)
    case customError(String)
}

// Protocol for the API manager
protocol APIManagerProtocol {
    func fetchData<T: Decodable>(
        method: HTTPMethod,
        path: String,
        headers: HTTPHeaders?,
        parameters: Parameters?
    ) -> AnyPublisher<T, APIError>
}


class APIManager: APIManagerProtocol {
    static let shared = APIManager()
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private var decoder: JSONDecoder
    private let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    private let session: Session
    
    private init(session: Session = Session.default) {
        self.session = session
        self.decoder = JSONDecoder()
        // Add custom decoding strategy if needed
//        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Start monitoring network reachability
        networkReachabilityManager?.startListening { status in
            switch status {
            case .reachable:
                print("Network reachable")
            case .notReachable:
                print("Network not reachable")
            case .unknown:
                print("Network status unknown")
            }
        }
    }
    
    func fetchData<T: Decodable>(
        method: HTTPMethod,
        path: String,
        headers: HTTPHeaders? = nil,
        parameters: Parameters? = nil
    ) -> AnyPublisher<T, APIError> {
        guard let networkReachabilityManager = networkReachabilityManager, networkReachabilityManager.isReachable else {
            return Fail(error: APIError.noInternetConnection).eraseToAnyPublisher()
        }
        
        guard let requestURL = URL(string: baseURL)?.appendingPathComponent(path) else {
            return Fail(error: APIError.invalidPath).eraseToAnyPublisher()
        }
        
        return Future<T, APIError> { promise in
            AF.request(requestURL, method: method, parameters: parameters, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self, decoder: self.decoder) { response in
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            promise(.failure(.unauthorized))
                        } else {
                            promise(.failure(.failureError(error)))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

// Mock implementation of the API manager for testing purposes
//class APIManagerMock: APIManagerProtocol {
//    func fetchData<T: Decodable>(
//        method: HTTPMethod,
//        path: String,
//        headers: HTTPHeaders?,
//        parameters: Parameters?
//    ) -> AnyPublisher<T, APIError> {
//        // Mock implementation for testing purposes
//        // You can provide predefined responses or simulate different scenarios
//        return Empty<T, APIError>().eraseToAnyPublisher()
//    }
//}
