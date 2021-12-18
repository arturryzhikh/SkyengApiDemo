//
//  ImageFetcher.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit


final class ImageFetcher {
    
    static let shared = ImageFetcher(
        responseQueue: .main,
        session: URLSession.shared
    )
    
    private(set) var cachedImageForURL: [String: UIImage]
    private(set) var cachedTaskForImageView: [UIImageView : Networking]
    
    let responseQueue: DispatchQueue?
    let session: URLSession
    
    init(responseQueue: DispatchQueue?, session: URLSession) {
        self.cachedImageForURL = [:]
        self.cachedTaskForImageView = [:]
        
        self.responseQueue = responseQueue
        self.session = session
    }
    
    private func dispatchImage(image: UIImage? = nil,
                               error: Error? = nil,
                               completion: @escaping (UIImage?, Error?) -> Void) {
        
        guard let responseQueue = responseQueue else {
            completion(image, error)
            return
        }
        
        responseQueue.async {
            completion(image, error)
        }
    }
}

extension ImageFetcher: ImageFetching {
    
    func downloadImage<Request: NetworkDataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let networkService: Networking = ApiService.shared
        
        networkService.request(request) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                guard let image: UIImage = response as? UIImage else {
                    return
                }
                
                self.dispatchImage(image: image, completion: completion)
            case .failure(let error):
                self.dispatchImage(error: error, completion: completion)
            }
        }
    }
    
    
    
    func setImage(from url: String, placeholderImage: UIImage? = nil, completion: @escaping (UIImage?) -> Void) {
        
        let request = ImageRequest(url: url)
        if let cacheImage = cachedImageForURL[url] {
            completion(cacheImage)
        } else {
            downloadImage(request: request) { [weak self] image, error in
                guard let self = self else { return }
                guard let image = image else { return}
                self.cachedImageForURL[url] = image
                completion(self.cachedImageForURL[url])
            }
        }
    }
}
