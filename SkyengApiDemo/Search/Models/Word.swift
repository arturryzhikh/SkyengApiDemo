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
   
    
    
    var previewName: String = ""
    var imageName: String = ""
    var soundName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id,partOfSpeechCode, translation,
             transcription, previewUrl, imageUrl, soundUrl
    }
   
    //MARK: life cycle
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //api returns url without scheme , so add it while decoding
        let scheme = "https:"
        id = try container.decode(Int.self, forKey: .id)
        partOfSpeechCode = try container.decode(String.self, forKey: .partOfSpeechCode)
        translation = try container.decode(Translation.self, forKey: .translation)
        previewUrl = try scheme + container.decode(String.self, forKey: .previewUrl)
        imageUrl = try scheme + container.decode(String.self, forKey: .imageUrl)
        soundUrl = try scheme + container.decode(String.self, forKey: .soundUrl)
        transcription = try container.decode(String.self, forKey: .transcription)
        
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
        object.previewName = self.previewName
        object.imageName = self.imageName
        object.soundName = self.soundName
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
        self.previewName = managedObject.previewName
        self.imageName = managedObject.imageName
        self.soundName = managedObject.soundName
    }
}

