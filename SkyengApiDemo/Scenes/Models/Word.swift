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
        return "text"
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
