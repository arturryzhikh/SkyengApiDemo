//
//  Translation.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift

@objcMembers public class Translation: Object , Decodable {
    
    dynamic var text: String = ""
    dynamic var note: String? = nil
    
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

