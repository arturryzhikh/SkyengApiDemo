//
//  Word.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 24.12.2021.
//

import Foundation

struct Word: Decodable {
    let id: Int
    let text: String
    let meanings: [Meaning2]
}

struct Meaning2: Decodable {
    var id: Int = 0
    var translation: Translation
    var transcription: String = ""
    var partOfSpeechCode: String = ""
    var previewUrl: String = ""
    var imageUrl: String = ""
    var soundUrl: String = ""
    init(from decoder: Decoder) throws {
        
    }
}
struct Translation: Decodable {
    var text: String = ""
    var note: String?
}
extension Word: RealmManagable {
    init(managedObject: WordObject) {
        self.id = managedObject.id
        self.text = managedObject.text
        self.meanings = managedObject.meanings.map { meaning2Object in
            Meaning2(managedObject: meaning2Object)
        }

    }

    func managedObject() -> WordObject {
        let object = WordObject()
        object.id = self.id
        object.text = self.text
        self.meanings.forEach { meaning in
            object.meanings.append(meaning.managedObject())
            
        }
        return object
    }
  }
extension Meaning2: RealmManagable {
    
    func managedObject() -> Meaning2Object {
        let object = Meaning2Object()
        object.id = self.id
        object.translation = self.translation.text
        object.note = self.translation.note
        object.partOfSpeechCode = self.partOfSpeechCode
        object.previewUrl = self.previewUrl
        object.imageUrl = self.imageUrl
        object.soundUrl = self.soundUrl
        return object
    }
    
    init(managedObject: Meaning2Object) {
        self.id = managedObject.id
        var translation = Translation()
        translation.text = managedObject.translation
        translation.note = managedObject.note
        self.translation = translation
        self.translation.note = managedObject.note
        self.transcription = managedObject.transcription
        self.previewUrl = managedObject.previewUrl
        self.imageUrl = managedObject.imageUrl
        self.soundUrl = managedObject.soundUrl
    }
}

