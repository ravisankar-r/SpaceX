//
//  ApiService.swift
//  SpaceX
//
//  Created by Ravisankar on 25/01/21.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case genericError
    case invalidURL
}

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithURL(wity request: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

final class ApiService {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Codable>(with endPoint: EndPoint) -> Observable<T> {
        
        guard let request = endPoint.urlRequest else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return Observable.create { [weak self] observer in
            
            let task = self?.session.dataTaskWithURL(wity: request,
                                                     completion: { (data, response, error) in
                                                        
                                                        guard let responseData = data else {
                                                            return observer.onError(error ?? NetworkError.genericError)
                                                        }
                                                        do {
                                                            let json = try JSONDecoder().decode(T.self, from: responseData)
                                                            observer.onNext(json)
                                                        } catch let error {
                                                            print(error)
                                                            return observer.onError(error )
                                                        }
                                                     })
            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithURL(wity request: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        dataTask(with: request, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
