//
//  Meaning2.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift


@objcMembers public class Meaning2: Object, Decodable {
    
    dynamic var word: String = ""
    dynamic var id: Int = 0
    dynamic var partOfSpeechCode: String = ""
    dynamic var translation: Translation?
    dynamic var transcription: String = ""
    var previewUrl: String = ""
    var imageUrl: String = ""
    var soundUrl: String = ""
    //file names after saving in db
    dynamic var previewImageName: String = ""
    dynamic var imageName: String = ""
    dynamic var soundName: String = ""
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    //Decodable
    enum CodingKeys: String, CodingKey {
        case id,partOfSpeechCode, translation,
             transcription, previewUrl, imageUrl, soundUrl
    }
   
    //MARK: life cycle
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //api returns url without scheme , so add it while decoding
        let scheme = "https:"
        id = try container.decode(Int.self, forKey: .id)
        partOfSpeechCode = try container.decode(String.self, forKey: .partOfSpeechCode)
        translation = try? container.decode(Translation.self, forKey: .translation)
        previewUrl = try scheme + container.decode(String.self, forKey: .previewUrl)
        imageUrl = try scheme + container.decode(String.self, forKey: .imageUrl)
        soundUrl = try scheme + container.decode(String.self, forKey: .soundUrl)
        transcription = try container.decode(String.self, forKey: .transcription)
        super.init()
    }
    
    required override init() {
        super.init()
    }
    
}







