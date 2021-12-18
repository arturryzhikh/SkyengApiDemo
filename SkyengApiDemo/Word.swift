//
//  Word.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import RealmSwift
import Realm



@objcMembers public class Word: Object, Decodable, SectionViewModel  {
    
    dynamic var id: Int = 0
    dynamic var text: String = ""
    let meanings = List<Meaning2>()
    //ignoring properties
    public var collapsed = false {
        didSet {
            cellViewModels = makeCellViewModels(collapsed: collapsed)
        }
    }
    var meaningsCount: String {
        return "\(meanings.count)"
    }
    func joinTranslationsIntoOneString(length: Int) -> String {
        var result = (cellViewModels.first?.translation?.text ?? "") + ", "
        //show only a FEW translations in on string ,separated by a comma
        var start = 1
        for index in start..<cellViewModels.count {
            guard result.count < length else { return result }
            if let translation = cellViewModels[index].translation?.text {
                //add comma or don't if sting larger then 30
                let separator = (result.count + translation.count < length) ? ", " : ""
                result.append(translation + separator)
                start += 1
            }
        }
        result.removeLast()
        result.removeLast()
        return result
    }
    
    public lazy var cellViewModels: [Meaning2] = {
        makeCellViewModels(collapsed: collapsed)
    }()
    
    private  func makeCellViewModels(collapsed: Bool) -> [Meaning2] {
        return collapsed ? [] : meanings.compactMap { meaning in
            if let cachedMeaning = RealmManager
                .shared?
                .object(ofType: Meaning2.self, forPrimaryKey: meaning.id) {
                return cachedMeaning
            } else {
                meaning.word = text
                return meaning
            }
        }
    }
    
    public override static func ignoredProperties() -> [String] {
        return ["cellViewModels"] //ignore this in realm property explicitly
    }
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
