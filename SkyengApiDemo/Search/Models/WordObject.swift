//
//  Word.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift
import Realm



@objcMembers public class WordObject: Object  {
    
    dynamic var id: Int = 0
    dynamic var text: String = ""
    let meanings = List<Meaning2Object>()
    
    public override class func primaryKey() -> String? {
        return "text"
    }

    
}

@objcMembers public class Meaning2Object: Object {
    
    dynamic var id: Int = 0
    dynamic var translation: String =  ""
    dynamic var note: String? = nil
    dynamic var transcription: String = ""
    dynamic var partOfSpeechCode: String = ""
    
    dynamic var previewUrl: String = ""
    dynamic var imageUrl: String = ""
    dynamic var soundUrl: String = "" 

    dynamic var previewName: String = ""
    dynamic var imageName: String = ""
    dynamic var soundName: String = ""
    
    public override class func primaryKey() -> String? {
        return "id"
    }

}
