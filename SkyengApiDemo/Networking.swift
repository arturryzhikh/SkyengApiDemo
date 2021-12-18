//
//  Networking.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation

public enum ResponseError: Error {
    
    case network
    case decoding
    case invalidEndPoint
    case invalidResponse
    
    var reason: String {
        switch self {
        case .network:
            return "failed network fetching"
        case .decoding:
            return "failed decoding data"
        case .invalidEndPoint:
            return "bad url"
        case .invalidResponse:
            return "Could not decode into valid response"
        }
    }
}

public protocol Networking {
    
    func request<Request: NetworkDataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
    
}


