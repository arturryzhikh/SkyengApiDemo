//
//  MeaningDetailViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//


import UIKit

final class MeaningDetailViewModel {
    
    let word: String
    let indexPath: IndexPath
    let meaning: Meaning2
    
    var isSaved: Bool {
        return Meaning2Object.isSaved(forPrimaryKey: meaning.id)
    }
    var translation: String {
        return meaning.translation.text
    }
    var transcription: String {
        return "· Transcription: [ \(meaning.transcription) ]"
    }
    var note: String {
        guard let note = meaning.translation.note else { return "" }
        return note.isEmpty ? "" : "(\(note))"
    }
    var partOfSpeech: String {
        return "· Part of speech: \(PartOfSpeech(rawValue: meaning.partOfSpeechCode)?.text ?? "")"
    }
    private var imageUrl: String {
        return meaning.imageUrl
    }
    private var soundUrl: String {
        return meaning.soundUrl
    }
    func image(completion: @escaping (UIImage?) -> Void) {
        //get images from network or local
        if isSaved {
            let image = FileStoreManager.shared.loadImage(named: imageUrl)
            completion(image)
        } else {
            ImageFetcher.shared.setImage(from: imageUrl) { image in
                completion(image)
            }
        }
    }
    
    func soundData(completion: @escaping (Data?) -> Void) {
        if isSaved {
            let data = FileStoreManager.shared.loadSound(named: soundUrl)
            completion(data)
        } else {
            guard let url = URL(string: meaning.soundUrl) else {
                completion(nil)
                return
            }
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        completion(data)
                    }
                } catch {
                    completion(nil)
                }
                
            }
        }
    }
    
    func save() {
        
    }
    
    func delete() {
        
    }
    
    init (word: String, meaning: Meaning2, indexPath: IndexPath) {
        self.word = word
        self.meaning = meaning
        self.indexPath = indexPath
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
