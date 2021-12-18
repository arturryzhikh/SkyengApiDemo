//
//  ApiService.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation

public final class ApiService: Networking {
    
    private init() {}
    
    static let shared = ApiService()
    
    public func request<Request: NetworkDataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: ResponseError.invalidEndPoint.reason,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: ResponseError.invalidEndPoint.reason,
                code: 404,
                userInfo: nil
            )
            
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode else {
                    return completion(.failure(NSError()))
                }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

