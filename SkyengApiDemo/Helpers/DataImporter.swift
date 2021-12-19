//
//  DataImporter.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 19.12.2021.
//



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
 
    func getDataFor(_ object: Meaning2Object,
                    completion: @escaping( Result<Meaning2Object, Error> ) -> Void) {
        do {
            
        }
        
        ImageFetcher
            .shared
            .downloadImage(request: ImageRequest(url: object.imageUrl)) { image, error in
                
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
                          compressionQuality: 0.25),
                  let imageName = FileStoreManager
                    .shared
                    .save(image: image,
                          name: "\(object.id)" + "i") else {
                        completion(.failure(DataImportError.savingImages))
                        return
                    }
            //set cached images names to meaning
            object.previewUrl = previewImageName
            object.imageUrl = imageName
            completion(.success(object))
            
        }
    }
}
