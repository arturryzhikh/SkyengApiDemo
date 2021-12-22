//
//  MeaningDetailViewModel.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 22.12.2021.
//


final class MeaningDetailViewModel {
    
    let word: String
    
    let meaning: Meaning2
    
    var isSaved: Bool {
        return meaning.isSaved(forPrimaryKey: meaning.id)
    }
    var translation: String {
        return meaning.translation?.text ?? ""
    }
    var transcription: String {
        return "· Transcription: [ \(meaning.transcription) ]"
    }
    var note: String {
        
        guard let translation = meaning.translation,
                let note = translation.note else { return "" }
        return note.isEmpty ? "" : "(\(note))"
    }
    var partOfSpeech: String {
        return "· Part of speech: \(PartOfSpeech(rawValue: meaning.partOfSpeechCode)?.text ?? "")"
    }
    var imageUrl: String {
        return meaning.imageUrl
    }
    var soundUrl: String {
        return meaning.soundUrl
    }
    
    func save() {
        
    }
    func delete() {
        
    }
    init (word: String, meaning: Meaning2) {
        self.word = word
        self.meaning = meaning
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
