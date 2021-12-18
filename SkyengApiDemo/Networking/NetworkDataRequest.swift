//
//  NetworkDataRequest.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol NetworkDataRequest {
    associatedtype Response
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }
    func decode(_ data: Data) throws -> Response
}

extension NetworkDataRequest {
    var headers: [String: String] { return [:] }
    var queryItems: [String: String] { [:] }
}

extension NetworkDataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
