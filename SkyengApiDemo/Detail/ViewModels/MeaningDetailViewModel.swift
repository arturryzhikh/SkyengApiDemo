//
//  MeaningDetailViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//


import UIKit

final class MeaningDetailViewModel {
    
    let word: Word
    let indexPath: IndexPath
    var meaning: Meaning2
    
    weak var delegate: MeaningDetailDelegate?
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
            let image = FileStoreManager.shared.loadImage(named: meaning.imageName)
            completion(image)
        } else {
            ImageFetcher.shared.setImage(from: imageUrl) { image in
                completion(image)
            }
        }
    }
    
    func soundData(completion: @escaping (Data?) -> Void) {
        if isSaved {
            let data = FileStoreManager.shared.loadSound(named: meaning.soundName)
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
    //Delete object / save object if its not saved
    func manageModel(_ completion: @escaping (Meaning2?) -> Void) {
        guard let realmManager = RealmManager.shared else {return}
        if isSaved {
            realmManager.deleteMeaning(with: meaning.id, for: word.text) { meaning in
                guard let meaning = meaning else {
                    completion(nil)
                    return
                }
                self.meaning = meaning
                completion(meaning)
            }
        } else {
            var wordToSave: WordObject
            if let cached = realmManager.object(ofType: WordObject.self, forPrimaryKey: word.text) {
                wordToSave = cached
            } else {//create new one with data from word from internet ,but without meanings
                wordToSave = WordObject()
                wordToSave.id = word.id
                wordToSave.text = word.text
            }
            let dataImporter = DataImporter.shared
            dataImporter.getDataFor(meaning.managedObject()) { result in
                switch result {
                case .failure(let error):
                    print("\(error)")
                    completion(nil)
                    return
                case.success(let meaning):
                    realmManager.update(wordToSave, with: [meaning] ) { error in
                        guard error == nil else {
                            completion(nil)
                            return
                        }
                        let meaning = Meaning2(managedObject: meaning)
                        self.meaning = meaning
                        completion(meaning)
                    }
                    
                }
            }
        }
    }
    
    
    


init (word: Word, meaning: Meaning2, indexPath: IndexPath) {
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
