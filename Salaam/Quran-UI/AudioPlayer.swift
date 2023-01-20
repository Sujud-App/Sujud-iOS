//
//  AudioPlayer.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import Foundation
import SwiftAudioEx

class MyAudioPlayer: Player {
    
    internal var player: AudioPlayer?
    internal var toPlayItem: AudioItem?
    var playlist: [String] = []
    var index: Int = -1
    
    var onIndexChange: (Int) -> Void
    
    init(playlist: [String], onIndexChange: @escaping((Int) -> Void)) {
        self.onIndexChange = onIndexChange
        self.index = 0
        self.onIndexChange(index)
        self.playlist = playlist
        setAudio()
    }
    
    func setAudio() {
        
        guard index < playlist.count else {
            onIndexChange(-1)
            destroy()
            return
        }
        let newItem = DefaultAudioItem(audioUrl: playlist[index], sourceType: .stream)
        toPlayItem = newItem
        player = AudioPlayer()
        do {
            try player!.load(item: toPlayItem!, playWhenReady: true)
            player?.event.stateChange.addListener(self, handleAudioPlayerStateChange)
            index += 1
            onIndexChange(index)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func destroy() {
        
        guard toPlayItem != nil else { return }
        player = nil
        toPlayItem = nil
        print("destroyed")
    }
    
    func handleAudioPlayerStateChange(state: AudioPlayerState) {
        switch state {
            case .idle:
                print("idle")
            case .paused:
                setAudio()
            case .loading:
                print("loading")
            case .buffering:
                print("buffering")
            case .ready:
                print("ready")
            case .playing:
                print("playing")
        }
    }
}
