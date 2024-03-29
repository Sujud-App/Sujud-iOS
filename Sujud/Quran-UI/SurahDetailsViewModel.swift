//
//  SurahDetailsViewModel.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//


import SwiftUI
import AVKit

extension SurahDetailsView {
    
    class ViewModel: ObservableObject {

        @Published var currentSurah: AyehItemModel? = nil
        @Published var showBismellah: Bool = true

        var fileManager: FileManager? = nil
        
        @Published var playingAyeNumber: Int = -1
        @AppStorage("playing-url") var playingURL: Int = 0
        

        
        @AppStorage("translate-fontsize") var translateFontSize = 22.0
        @AppStorage("translate") var showingTranslate: String = "English"
        
        var player: MyAudioPlayer? = nil
        
        let playingURLS = [
            "https://www.everyayah.com/data/Alafasy_128kbps/",
        ]
        
        init() {
            fileManager = FileManager()
        }
        
        func loadDetails(of surah: SurahItem?) {
            showBismellah = false
            currentSurah = loadOneSurah(index: surah?.id ?? -1)
            if let currentSurah = currentSurah {
                if let extra = currentSurah.extra {
                    if extra.contains("no-bism") {
                        showBismellah = false
                    }
                } else {
                    showBismellah = true
                }
            }
        }
        

        
        

        
        private func numberGenerator(number: Int) -> String {
            if number < 10 {
                return "00\(number)"
            } else if number >= 10 && number <= 99 {
                return "0\(number)"
            } else {
                return "\(number)"
            }
        }
        
        func createPlayList(first: Int) -> [String] {
            
            guard let currentSurah = currentSurah else { return [] }

            
            var playlist = [String]()
            for index in first...currentSurah.total_verses {
                
                let current = playingURLS[playingURL] + "\(numberGenerator(number: currentSurah.number))\(numberGenerator(number: index)).mp3"
                
                playlist.append(current)
            }
            
            return playlist
        }
        
        func play(aye: Int) {
            guard player != nil else {
                let playlist = createPlayList(first: aye)
                
                player = MyAudioPlayer(playlist: playlist) { [weak self] index in
                    DispatchQueue.main.async {
                        self?.playingAyeNumber = index + aye - 1

                    }
                }
                player?.player?.play()
                
                return
            }
            
            player?.destroy()
            self.playingAyeNumber = -1
            self.player = nil
            
        }
        
        func playButtonTapped(aye: Int) {
            playingAyeNumber = aye
            play(aye: aye)
        }
        
        func pauseButtonTapped(aye: Int) {
            playingAyeNumber = -1
            self.player = nil
            return
        }

        
    }
    
}
