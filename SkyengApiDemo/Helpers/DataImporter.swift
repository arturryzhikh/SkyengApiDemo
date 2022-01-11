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

final class DataImporter {
    
    let imageFetcher: ImageFetching
    
    let fileStoreManager: FileStoreManaging
    
    init(fileStoreManager: FileStoreManaging = FileStoreManager(),
         imageFetcher: ImageFetching = ImageFetcher()) {
        self.imageFetcher = imageFetcher
        self.fileStoreManager = fileStoreManager
    }
    func getDataFor(_ object: Meaning2Object,
                    completion: @escaping( Result<Meaning2Object, Error> ) -> Void) {
       
        imageFetcher.downloadImage(request: ImageRequest(url: object.previewUrl)) { image, error in
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
                
            guard let previewImageName = self.fileStoreManager.save(image: image, name: "\(object.id)" + "p"),
                  let imageName = self.fileStoreManager.save(image: image,name: "\(object.id)" + "i"),
                  let soundName = self.fileStoreManager.saveSound(data: soundData, name: "\(object.id)") else {
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
