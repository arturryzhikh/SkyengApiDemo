//
//  RealmManager.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift
import Foundation


public final class RealmManager {
    
    static let shared = RealmManager()
    private let realm: Realm
    private init?() {
        do {
            try self.realm = Realm()
        } catch  let error as NSError {
            print("Could not get realm object error: \(error)")
            return nil
        }
    }
    //MARK: CRUD
    //Save object
    func update(_ word: WordObject,
                with meanings: [Meaning2Object], _ completion: (Error?) -> Void)   {
        do {
            try realm.write {
                meanings.forEach {
                   word.meanings.append($0)
                }
                realm.add(word, update: .modified)
                completion(nil)
            }
        } catch let error as NSError {
            print("RealmManager could not update \(word) with meanings: \(meanings). Error: \(error)")
            completion(error)
        }

    }
    
    func deleteMeaning(with Id: Int, for word: String, _ completion: (Meaning2?) -> Void ) {
        guard let word = realm.object(ofType: WordObject.self, forPrimaryKey: word),
              let meaning = realm.object(ofType: Meaning2Object.self, forPrimaryKey: Id) else {
                  completion(nil)
                  return
              }
        do {
            let meaningStruct = Meaning2(managedObject: meaning)
            try realm.write {
                realm.delete(meaning)
                completion(meaningStruct)
                if word.meanings.isEmpty {
                    realm.delete(word)
                }
               
            }
            
        } catch let error as NSError {
            print("Could not delete object",error)
            completion(nil)
        }
    }
    //fetch specific object by primary key
    func object<Element:Object,KeyType>(ofType: Element.Type,
                                        forPrimaryKey: KeyType) -> Element? {
        return realm.object(ofType: ofType, forPrimaryKey: forPrimaryKey)
    
    }
   
  
}

extension Object {
    
    static func isSaved<KeyType>(forPrimaryKey: KeyType) -> Bool {
        return try! Realm().object(ofType: Self.self, forPrimaryKey: forPrimaryKey) != nil
    }
    
}
