//
//  Word.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift
import Realm



@objcMembers public class Word: Object, Decodable  {
    
    dynamic var id: Int = 0
    dynamic var text: String = ""
    let meanings = List<Meaning2>()
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    enum CodingKeys: String, CodingKey {
        case id, text, meanings
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        let meaning = try container.decode([Meaning2].self, forKey: .meanings)
        meanings.append(objectsIn: meaning)
        super.init()
    }
    
    required override init() {
        super.init()
    }
    
    
}

@objcMembers public class Meaning2: Object, Decodable {
    
    dynamic var id: Int = 0
    dynamic var translation: Translation?
    dynamic var transcription: String = ""
    dynamic var partOfSpeechCode: String = ""
    //    let ofWord = LinkingObjects<WordObject>(fromType: WordObject.self, property: "meanings")
    var partOfSpeech: String? {
        return PartOfSpeech(rawValue: partOfSpeechCode)?.text
    }
    dynamic var previewUrl: String = ""
    dynamic var imageUrl: String = ""
    dynamic var soundUrl: String = "" 
    
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
@objcMembers public class Translation: Object , Decodable {
    
    dynamic var text: String = ""
    dynamic var note: String?
//    let ofMeaning = LinkingObjects<Meaning2>(fromType: Meaning2.self, property: "translation")
    enum CodingKeys: String, CodingKey {
        case text, note
    }
    //MARK:  life cycle
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        note = try? container.decode(String.self, forKey: .note)
        super.init()
        
    }
    required override init() {
        super.init()
    }
  
    
}
fileprivate enum PartOfSpeech: String {
    
    case n = "n"
    case v = "v"
    case j = "j"
    case r = "r"
    case prp = "prp"
    case prn = "prn"
    case crd = "crd"
    case cjc = "cjc"
    case exc = "exc"
    case det = "det"
    case abb = "abb"
    case x = "x"
    case ord = "ord"
    case md = "md"
    case ph = "ph"
    case phi = "phi"
    
    var text: String {
        
        switch self {
        case .n:
            return "noun"
        case .v:
            return "verb"
        case .j:
            return "adjective"
        case .r:
            return "adverb"
        case .prp:
            return "preposition"
        case .prn:
            return "pronoun"
        case .crd:
            return "cardinal number"
        case .cjc:
            return"conjunction"
        case .exc:
            return "interjection"
        case .det:
            return "article"
        case .abb:
            return "abbreviation"
        case .x:
            return "particle"
        case .ord:
            return "ordinal number"
        case .md:
            return "modal verb"
        case .ph:
            return "phrase"
        case .phi:
            return "idiom"
        }
    }
    
    
}
