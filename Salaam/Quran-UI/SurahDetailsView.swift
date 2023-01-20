//
//  SurahDetailsView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import SwiftUI

struct SurahDetailsView: View {
    // MARK: - PROPERTIES
    let textAspect = 1.0
    
    @StateObject private var viewModel = ViewModel()
    
    let detailCardWidth = 327.0 * UIScreen.main.bounds.width / 374.0
    let detailCardHeight = 257.0 * UIScreen.main.bounds.height / 812.0
    let detailRounded = 20.0 * UIScreen.main.bounds.height / 812.0
    
    let detailDotHeight = 4.0 * UIScreen.main.bounds.height / 812.0
    
    let detailBesmHeight = 48.0 * UIScreen.main.bounds.height / 812.0
    
    let ayatSectionHeaderBGHeight = 47.0 * UIScreen.main.bounds.height / 812.0
    let ayatSectionHeaderBGRound = 10.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemActionButtonHeight = 24.0 * UIScreen.main.bounds.height / 812.0
    let ayatItemIndexDotBGHeight = 27.0 * UIScreen.main.bounds.height / 812.0
    
    let FolderItemIndexHeight = 40.0 * UIScreen.main.bounds.height / 812.0
    let FolderItemBookmarkHeight = 32.0 * UIScreen.main.bounds.height / 812.0
    
    let fontStyleItemHeight = 52.0 * UIScreen.main.bounds.height / 812.0
    let fontStyleItemWidth = UIScreen.main.bounds.width - 48.0
    @Namespace var namespace
    
    let languages = ["English", "Indonesian"]
    
    var surah: SurahItem?
    var aye: Int? = -1

    init(surah: SurahItem?, aye: Int = -1) {
        self.surah = surah
        self.aye = aye
    }
    
    
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24.0) {

                
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer()
                    ScrollViewReader { proxy in
                        AyatView()
                        Spacer(minLength: ayatSectionHeaderBGHeight)
                    }
                }
                .navigationBarTitle(
                    Text("\(surah?.en_name ?? "Surah")")
                )
                .navigationBarTitleDisplayMode(.large)
                
            }
        }
        .padding(.horizontal, 24.0)
     
        
        .onAppear {
            viewModel.loadDetails(of: surah)
            if let aye = aye {
                viewModel.playingAyeNumber = aye
            }
        }
        
    }

    
    // MARK: - DetailCardView
    @ViewBuilder
    func DetailCardContentView() -> some View {
        HStack(alignment: .center, spacing: 2) {
            
            Text(surah?.en_name ?? "Surah")
            Text(": ")
            Text(surah?.en_meaning ?? "Meaning")
        }
    }
    
    @ViewBuilder
    func DetailCardView() -> some View {
        
        ZStack(alignment: .center) {
            DetailCardContentView()
        }
    }
    
    
    
    
    
    // MARK: - AyatView
    @ViewBuilder
    func AyatItemActionButtonView(name: String) -> some View {
        Image(name)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: ayatItemActionButtonHeight)
    }
    
    @ViewBuilder
    func AyatItemView(aye: VerseItemModel) -> some View {
        VStack(alignment: .leading, spacing: 24.0) {
            ZStack {
                HStack(alignment: .center, spacing: 16.0) {
                    ZStack {
                        Text("\(aye.number.description)")
                            .frame(width: ayatItemIndexDotBGHeight, height: ayatItemIndexDotBGHeight)
                            .background(Color.init("bar").opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                    
                    Spacer()
                    
                    AyatItemActionButtonView(name: (viewModel.playingAyeNumber == aye.number && viewModel.player != nil) ? "ayat-section-header-pause-image-active" : "ayat-section-header-play-image")
                        .onTapGesture {
                            viewModel.play(aye: aye.number)
                        }
                }
                .padding(.horizontal, 13.0)
            }
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text(aye.text)
                    .font(.system(size: 25))
                    .lineSpacing(7)
            }
            
            Text(viewModel.showingTranslate == "English" ? aye.translation_en : aye.translation_id)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: ayatSectionHeaderBGRound))
            if (aye.number != surah?.aya_count) {
                
            }
        }
        .padding(15)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: ayatSectionHeaderBGRound))
        
    }
    
    @ViewBuilder
    func AyatView() -> some View {
        if let currentSurah = viewModel.currentSurah {
            LazyVStack(alignment: .center, spacing: 24.0) {
                ForEach(currentSurah.verses, id: \.self) { verse in
                    AyatItemView(aye: verse)
                        .id(verse.number)
                }
            }
        }
    }
}
