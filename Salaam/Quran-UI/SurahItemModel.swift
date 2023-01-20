//
//  SurahItemModel.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import Foundation


struct SurahItem: Codable, Hashable, Identifiable {
    let id: Int
    let url: String
    let icon: String
    let en_name: String
    let en_meaning: String
    let type: String
    let aya_count: Int
    let start_ayah: Int
    let order: Int?
    let word_count: Int
    let the_letter: Int
    let juz: String
    let page: String
}

func loadSurahs() -> [SurahItem] {
    let decoder = JSONDecoder()
    if let url = Bundle.main.url(forResource: "surah-details", withExtension: "json") {
        if let jsonData = try? Data(contentsOf: url) {
            if let surahs = try? decoder.decode([SurahItem].self, from: jsonData) {
                return surahs
            } else {
                print("error while decoding json")
            }
        }
    }
    return []
    
}

func stringToUnicodeCharacter(string: String) -> String {
    if let number = UInt32(string, radix: 16) {
        if let scalar = UnicodeScalar(number) {
            return String(Character(scalar))
        }
    }
    return ""
}

var surahItemExample = loadSurahs()
