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
    func save(_ object: Object, completion: (Error?) -> Void)   {
        
        do {
            try realm.write {
                realm.add(object, update: .modified)
                completion(nil)
            }
        } catch let error as NSError {
            print("RealmManager could not save \(object). Error: \(error)")
            completion(error)
        }

    }
    //fetch specific object by primary key
    func object<Element:Object,KeyType>(ofType: Element.Type,
                                        forPrimaryKey: KeyType) -> Element? {
        return realm.object(ofType: ofType, forPrimaryKey: forPrimaryKey)
    
    }

 
  
}


public extension Object {
    
    ///Checks if object with given primeryKey is exists in DB
    static func exists<KeyType>(primaryKey: KeyType) throws -> Bool {
        do {
            return try Realm().object(ofType: Self.self,
                                      forPrimaryKey: primaryKey) != nil
        } catch let error as NSError {
            print("Could not obtain object of type: \(Self.self), Error: \(error)")
            throw error
        }
    }
}

