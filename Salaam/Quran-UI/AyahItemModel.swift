//
//  AyahItemModel.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import Foundation

enum surahSajdaType: String {
    case vajeb = "vajib"
    case qeir_vajib = "qeir-vajib"
}

enum surahExtra: String {
    case no_bism = "no-bism"
}

struct VerseItemModel: Codable, Hashable {
    let number: Int
    let text: String
    let extra: [String]?
    let translation_en: String
    let translation_id: String
    
}

struct AyehItemModel: Codable, Hashable {
    let number: Int
    let name: String
    let transliteration_en: String
    let translation_en: String
    let total_verses: Int
    let revelation_type: String
    let extra: [String]?
    let verses: [VerseItemModel]
}


func loadOneSurah(index: Int) -> AyehItemModel? {
    let decoder = JSONDecoder()
    if let potato = Bundle.main.url(forResource: "surah-\(index)", withExtension: "json") {
        if let jsonData = try? Data(contentsOf: potato) {
            if let surah = try? decoder.decode(AyehItemModel.self, from: jsonData) {
                return surah
            } else {
                print("error while decoding json")
            }
        }
    }
    return nil
}
