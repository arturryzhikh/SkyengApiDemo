//
//  ImageRequest.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

struct ImageRequest: NetworkDataRequest {

    typealias Response = UIImage
    
    var url: String
    var httpMethod: HTTPMethod = .get
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            let error = NSError(domain: ResponseError.invalidResponse.reason,code: 13,userInfo: nil)
            throw error
             }
        return image
    }
  
}
