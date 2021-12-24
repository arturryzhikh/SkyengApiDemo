//
//  RealmManagable.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 19.12.2021.
//

import RealmSwift

public protocol RealmManagable {
    
    associatedtype ManagedObject: RealmSwift.Object
    
    init(managedObject: ManagedObject)
    
    func managedObject() -> ManagedObject
    
}


