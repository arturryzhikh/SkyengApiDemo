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
    func update(_ word: Word,
                with meanings: [Meaning2], _ completion: (Error?) -> Void)   {
        do {
            try realm.write {
                meanings.forEach {
                    word.meanings.append($0)
                }
                realm.add(word, update: .modified)
                completion(nil)
            }
        } catch let error as NSError {
            print("RealmManager could not save \(word). Error: \(error)")
            completion(error)
        }

    }
    //fetch specific object by primary key
    func object<Element:Object,KeyType>(ofType: Element.Type,
                                        forPrimaryKey: KeyType) -> Element? {
        return realm.object(ofType: ofType, forPrimaryKey: forPrimaryKey)
    
    }
   
  
}

extension Object {
    
    func isSaved<KeyType>(forPrimaryKey: KeyType) -> Bool {
        return try! Realm().object(ofType: Self.self, forPrimaryKey: forPrimaryKey) != nil
    }
    
}
