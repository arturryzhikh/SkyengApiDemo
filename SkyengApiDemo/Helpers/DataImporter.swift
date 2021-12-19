//
//  DataImporter.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 19.12.2021.
//

import RealmSwift

enum DataImportError : Error {
    case objectExists
    case fetchingData
    case savingImages
}

protocol DataImporting {
    associatedtype Object
    var imageFetcher: ImageFetching { get }
    func getDataFor(_ object: Object, completion: @escaping(Result<Object,Error>) -> Void)
}

final class DataImporter: DataImporting {
    var imageFetcher: ImageFetching
    
    init(imageFethcer: ImageFetching = ImageFetcher.shared) {
        self.imageFetcher = imageFethcer
    }
 
   
    func getDataFor(_ object: Meaning2Object,
                    completion: @escaping(Result<Meaning2Object,Error>) -> Void) {
        guard let isExists = Meaning2Object.exists(primaryKey: object.id),
              !isExists else {
                  completion(.failure(DataImportError.objectExists))
                  return
              }
        imageFetcher.downloadImage(request: ImageRequest(url: object.imageUrl)) { image, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let image = image else {
                    completion(.failure(DataImportError.fetchingData))
                    return
                }
                guard let previewImageName = FileStoreManager
                        .shared
                        .save(image: image,
                              name: "\(object.id)" + "p",
                              compressionQuality: 1.0),
                      let imageName = FileStoreManager
                        .shared
                        .save(image: image,
                              name: "\(object.id)" + "i") else {
                            completion(.failure(DataImportError.savingImages))
                            return
                        }
            //wrire cached images names into meaning
            object.previewUrl = previewImageName
            object.imageUrl = imageName
            completion(.success(object))
            
        }
        
        
        
    }
}
