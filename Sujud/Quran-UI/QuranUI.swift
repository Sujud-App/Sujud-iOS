//
//  QuranUI.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import SwiftUI

struct QuranUI: View {
    var surah: SurahItem?
    var surahss = surahItemExample
    @State private var searchText = ""
    var body: some View {
        NavigationView{
            List{

                ForEach(surahItemExample, id:\.self) { surahs in
                        Section{
                        NavigationLink(destination: {
                            SurahDetailsView(surah: surahs)
                        }, label: {
                            Text("\(surahs.id.description)" )
                                .foregroundColor(Color.primary)
                                .frame(width : 45, height: 45)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text("\(surahs.en_name):" )
                            Text(surahs.en_meaning)
                        })
                    }
                }
                    
            }
            .navigationBarTitle("Quran")
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { searchText in
         
            if !searchText.isEmpty {
                surahItemExample = surahss.filter { $0.en_name.contains(searchText) }
            } else {
                surahItemExample = surahss
            }
        }
        .offset(y: -10)
        .background(Color.init("back"))
    }
}


