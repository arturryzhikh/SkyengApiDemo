//
//  Meaning2.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift

@objcMembers public class Meaning2: Object, Decodable {
    
    
    dynamic var isSaved: Bool = false
    dynamic var word: String = ""
    //
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




extension Meaning2 {
   
    
    var partOfSpeech: String {
        return PartOfSpeech(rawValue: partOfSpeechCode)?.text ?? ""
    }
 
    convenience init?(word: String, model: Meaning2) {
        self.init()
        guard !model.previewUrl.isEmpty else {
            return nil
        }
        self.word = word
        
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
        case .n: return "noun"
        case .v: return "verb"
        case .j: return "adjective"
        case .r: return "adverb"
        case .prp: return "preposition"
        case .prn: return "pronoun"
        case .crd: return "cardinal number"
        case .cjc: return"conjunction"
        case .exc: return "interjection"
        case .det: return "article"
        case .abb: return "abbreviation"
        case .x: return "particle"
        case .ord: return "ordinal number"
        case .md: return "modal verb"
        case .ph: return "phrase"
        case .phi: return "idiom"
        }
    }
    
    
}

