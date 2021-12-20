//
//  SearchRequest.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//
import Foundation
struct SearchRequest: NetworkDataRequest  {
    
    typealias Response = [WordObject]
    
    //FIXME: implement paginating request
    var searchText: String
    var page: Int = 0
    var pageSize: Int = 0
    var url: String = "https://dictionary.skyeng.ru/api/public/v1/words/search"
    
    var httpMethod: HTTPMethod = .get
    
    var queryItems: [String : String] {
        return [
            "search": searchText,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    
    init(_ searchText: String) {
        self.searchText = searchText
    }
    
    func decode(_ data: Data) throws -> [WordObject] {
        let decoder = JSONDecoder()
        let response = try decoder.decode([WordObject].self, from: data)
        return response
    }
    
}

