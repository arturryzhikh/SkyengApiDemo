//
//  DataImporter.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 19.12.2021.
//

import Foundation

enum DataImportError : Error {
    case objectExists
    case fetchingData
    case savingImages
   
}

protocol DataImporting {
    
    associatedtype Item
    func getDataFor(_ object: Item, completion: @escaping(Result<Item,Error>) -> Void)
    
}

final class DataImporter: DataImporting {
    static let shared = DataImporter()
    private init() {}
    func getDataFor(_ object: Meaning2Object,
                    completion: @escaping( Result<Meaning2Object, Error> ) -> Void) {
        do {
            
        }
        
        ImageFetcher
            .shared
            .downloadImage(request: ImageRequest(url: object.previewUrl)) { image, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard
                    let image = image,
                    let soundUrl = URL(string: object.soundUrl),
                    let soundData = try? Data(contentsOf: soundUrl) else {
                    completion(.failure(DataImportError.fetchingData))
                    return
                }
                
                guard let previewImageName = FileStoreManager.shared
                        .save(image: image, name: "\(object.id)" + "p"),
                      let imageName = FileStoreManager.shared
                        .save(image: image,name: "\(object.id)" + "i"),
                      let soundName = FileStoreManager.shared
                        .saveSound(data: soundData, name: "\(object.id)") else {
                            completion(.failure(DataImportError.savingImages))
                            return
                        }
                
                //set cached images names to meaning
                object.previewName = previewImageName
                object.imageName = imageName
                object.soundName = soundName
                completion(.success(object))
                
            }
    }
}
