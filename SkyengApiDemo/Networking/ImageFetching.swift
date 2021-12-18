//
//  ImageFetching.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

public protocol ImageFetching {
    func downloadImage<Request: NetworkDataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void)
   
    func setImage(from url: String, placeholderImage: UIImage?, completion: @escaping (UIImage?) -> Void)
}

