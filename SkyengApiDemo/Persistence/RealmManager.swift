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
    //MARK: Life cycle
    private init?()  {
        do {
            try self.realm = Realm()
        } catch let error as NSError {
            print("RrealmManager has not been initialized. Error: \(error)")
            return nil
        }
    }
    //MARK: CRUD
    //Save object
    func save(_ object: Object) -> Bool {
        do {
            try realm.write {
                realm.add(object)
            }
            return true
            
        } catch let error as NSError {
            print("RealmManager could not save \(object). Error: \(error)")
            return false
            
        }

    }
    //fetch specific object by primary key
    func object<Element:Object,KeyType>(ofType: Element.Type, forPrimaryKey: KeyType) -> Element? {
        return realm.object(ofType: ofType, forPrimaryKey: forPrimaryKey)
        
    }
    ///Checks if object with given primeryKey is exists in DB
 
  
}


public extension Object {
    ///Checks if object with given primeryKey is exists in DB
    static func exists<KeyType>(primaryKey: KeyType) -> Bool? {
        do {
            return try Realm().object(ofType: Self.self,
                                      forPrimaryKey: primaryKey) != nil
        } catch let error as NSError {
            print("Could not obtain object of type: \(Self.self), Error: \(error)")
            return nil
        }
       
      
    }
}

