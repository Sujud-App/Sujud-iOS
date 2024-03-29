import Foundation
import SwiftAudioEx
import AVKit
import UIKit

class MyAudioPlayer {
    
    internal var player: AudioPlayer?
    internal var toPlayItem: AudioItem?
    var playlist: [String] = []
    var index: Int = 0
    var timer: Timer?
    
    var onIndexChange: (Int) -> Void
    
    init(playlist: [String], onIndexChange: @escaping ((Int) -> Void)) {
        self.onIndexChange = onIndexChange
        self.playlist = playlist
        self.onIndexChange(index)
        setAudio()
    }
    
    func setAudio() {
        guard index < playlist.count else {
            destroy()
            onIndexChange(-1)
            return
        }

        let newItem = DefaultAudioItem(audioUrl: playlist[index], sourceType: .stream)
        toPlayItem = newItem

        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: .allowAirPlay)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }

        player = AudioPlayer()

        UIApplication.shared.beginReceivingRemoteControlEvents()

        player?.remoteCommands = [
            .play,
            .pause,
            .togglePlayPause,
            .skipForward(preferredIntervals: [5]),
            .skipBackward(preferredIntervals: [5])
        ]
        
        // Start a timer to print current time periodically
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard let player = self.player else { return }

            // Check if the current index is the last index of the playlist
            if self.index == self.playlist.count + 1{
                // If it's the last index, destroy the player
                self.destroy()
            } else {
                // If not the last index, proceed with setting audio for the next item
                if player.currentTime < player.duration - 0.1 && player.currentTime > player.duration - 0.2 {
                    self.setAudio()
                }
            }
        }


        do {
            try player!.load(item: toPlayItem!, playWhenReady: true)
            index += 1
            onIndexChange(index)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    

    func remoteControlReceived(with event: UIEvent?) {
        guard let event = event, event.type == .remoteControl else { return }
        
        switch event.subtype {
        case .remoteControlPlay, .remoteControlPause, .remoteControlTogglePlayPause:
            player?.togglePlaying()
        case .remoteControlNextTrack:
            player?.seek(to: player!.currentTime + 5)
        case .remoteControlPreviousTrack:
            player?.seek(to: player!.currentTime - 5)
        default:
            break
        }
    }
    
    func destroy() {
        timer?.invalidate() // Invalidate the timer before destroying the player
        player?.stop()
        player = nil
        toPlayItem = nil
        print("Player destroyed")
    }
}
