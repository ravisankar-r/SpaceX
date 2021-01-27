//
//  EndPoint.swift
//  SpaceX
//
//  Created by Ravisankar on 25/01/21.
//

import Foundation

enum HTTPMethod {
    case get
    case post(body: [String: Any])
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post(_):
            return "POST"
        }
    }
}

/// Endpoint struct can be used to represent an api endpoint. Endpoint can be initialized with just a path for GET requests or by adding
///  the http method , headers.
struct EndPoint {
    
    private let path: String
    private let httpMethod: HTTPMethod
    private var headers: [String: String]?
    
    init(path: String,
         httpMethod: HTTPMethod = .get,
         headers: [String: String]? = nil) {
        
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
    }
}

extension EndPoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.Network.scheme
        components.host = Constants.Network.baseUrlHost
        components.path = path
        return components.url
    }
    
    var urlRequest: URLRequest? {
        
        guard let url = url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        switch httpMethod {
        case .get: ()
        case .post(let body):
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        return request
    }
}
