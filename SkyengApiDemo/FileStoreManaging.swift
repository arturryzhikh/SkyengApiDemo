//
//  FileStoreManager.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

protocol FileStoreManaging: AnyObject {
    
    func loadImage(named: String) -> UIImage?
    func save(image: UIImage,
              name: String,
              compressionQuality: CGFloat) -> String?
    
}

protocol FileSystemStoreManagable {
    var fileManager: FileStoreManaging { get }
}


extension FileStoreManaging {
    //MARK: save image
    func save(image: UIImage, name: String, compressionQuality: CGFloat = 1.0) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let imageName = name + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: compressionQuality) else { return  nil }
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                
                try FileManager.default.removeItem(atPath: fileURL.path)
                
            } catch let removeError {
                print(removeError)
                return nil
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error)
            return nil
        }
        return imageName
    }
    
    
    //MARK: Load image
    func loadImage(named: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(named)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
    
    
}


