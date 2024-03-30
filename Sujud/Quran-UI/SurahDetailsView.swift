//
//  SurahDetailsView.swift
//  Harrow Mosque
//
//  Created by Muhammad Shah on 18/12/2022.
//

import SwiftUI
import AVKit
import UIKit
import AVFoundation

struct SurahDetailsView: View {
    @State private var isPlaying = false
    @State private var playerer: AVPlayer? // Retain player as a property
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
            if (surah?.id == 1) {
                EmptyView()
            }else{
                HStack{
                    Text("Tafseer by Nouman Ali Khan")
                    Spacer()
                    if let surahid = surah?.id.tothree(), let surahname = surah?.en_name {
                        AudioButton(surah: surahid, ayah: aye.number.tothree(), tafseerItem: "\(surahname) - Ayah \(aye.number)", uniqueID: "\(surahid)\(aye.number)")
                    }
                }
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

extension Int {
    func tothree() -> String {
        return String(format: "%03d", self)
    }
}

import AVFoundation
import MediaPlayer

var currentAudioPlayer: AVPlayer?

func PlayAudio(surah: String, ayah: String, tafseeritem: String) {
    
    let urlString = "https://s3.amazonaws.com/qhive-recite-all/nak-translation/\(surah)\(ayah).mp3"
    
    if let audioURL = URL(string: urlString) {
        let headers = [
            "Accept": "*/*",
            "Accept-Encoding": "identity",
            "Accept-Language": "en-GB,en;q=0.9",
            "Connection": "Keep-Alive",
            "Host": "s3.amazonaws.com",
            "Range": "bytes=0-1",
            "Referer": "https://quranhive.com/",
            "Sec-Fetch-Dest": "audio",
            "Sec-Fetch-Mode": "no-cors",
            "Sec-Fetch-Site": "cross-site",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15",
            "X-Playback-Session-Id": "61639E40-ADAA-4398-B430-0F2DCA8DF529"
        ]
        let asset = AVURLAsset(url: audioURL, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])

        let resourceLoaderDelegate = ResourceLoaderDelegate(headers: headers)
        asset.resourceLoader.setDelegate(resourceLoaderDelegate, queue: DispatchQueue.main)

        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)

        let progressView = AudioProgressView(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        progressView.player = player

        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            // Remove the previous audio player, if any
            currentAudioPlayer?.replaceCurrentItem(with: nil)

            // Set up remote control
            setupRemoteTransportControls(player: player)
            setupNowPlayingInfoCenter(player: player, url: audioURL, tafseeritem: tafseeritem)

            // Configure audio session to allow playback in the background
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .allowAirPlay)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to configure audio session:", error)
            }

            // Start playback
            player.play()

            // Update the current audio player reference
            currentAudioPlayer = player
        }
    } else {
        print("Invalid audio URL")
    }
}


func setupRemoteTransportControls(player: AVPlayer) {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.addTarget { event in
        if player.rate == 0.0 {
            player.play()
            return .success
        }
        return .commandFailed
    }

    commandCenter.pauseCommand.addTarget { event in
        if player.rate == 1.0 {
            player.pause()
            return .success
        }
        return .commandFailed
    }

    commandCenter.skipBackwardCommand.addTarget { event in
        let skipInterval: Double = 10 // Skip back 10 seconds
        let currentTime = player.currentTime().seconds
        let newTime = max(currentTime - skipInterval, 0)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
        return .success
    }

    commandCenter.skipForwardCommand.addTarget { event in
        let skipInterval: Double = 10 // Skip forward 10 seconds
        let currentTime = player.currentTime().seconds
        let duration = player.currentItem?.duration.seconds ?? 0
        let newTime = min(currentTime + skipInterval, duration)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1))
        return .success
    }
}

func setupNowPlayingInfoCenter(player: AVPlayer, url: URL, tafseeritem: String) {

    player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak player] time in
        guard let player = player else { return }
        guard let duration = player.currentItem?.duration else { return }

        let currentTime = CMTimeGetSeconds(time)
        let totalDuration = CMTimeGetSeconds(duration)

        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: tafseeritem,
            MPMediaItemPropertyArtist: "Nouman Ali Khan",
            MPMediaItemPropertyPlaybackDuration: totalDuration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

class AudioProgressView: UIProgressView {
    var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.progress = 0
        self.observedTime()
    }

    private func observedTime() {
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            guard let player = self.player else { return }
            guard let duration = player.currentItem?.duration else { return }

            let currentTime = CMTimeGetSeconds(time)
            let totalDuration = CMTimeGetSeconds(duration)

            let progress = Float(currentTime / totalDuration)
            self.setProgress(progress, animated: true)
        }
    }
}


class ResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
    private let headers: [String: String]
    
    init(headers: [String: String] = [:]) {
        self.headers = headers
        super.init()
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {
            loadingRequest.finishLoading(with: NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return false
        }
        
        var request = URLRequest(url: url)
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                loadingRequest.finishLoading(with: error)
                return
            }
            
            if response.statusCode == 200 {
                loadingRequest.dataRequest?.respond(with: data)
                loadingRequest.finishLoading()
            } else {
                loadingRequest.finishLoading(with: NSError(domain: "HTTP Error", code: response.statusCode, userInfo: nil))
            }
        }
        task.resume()
        
        return true
    }
}

import SwiftUI

struct AudioButton: View {
    var surah: String
    var ayah: String
    var tafseerItem: String
    var uniqueID: String // Unique identifier for the item in the list
    
    @State private var isPlaying = false
    
    var body: some View {
        Button(action: {
            if self.isPlaying {
                // Pause audio
                self.pauseAudio()
            } else {
                // Play audio
                self.playAudio()
            }
        }) {
            Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
                .foregroundColor(.blue)
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
            self.isPlaying = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemFailedToPlayToEndTime)) { _ in
            self.isPlaying = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemPlaybackStalled)) { _ in
            self.isPlaying = false
        }
    }
    
    func playAudio() {
        PlayAudio(surah: surah, ayah: ayah, tafseeritem: tafseerItem)
        self.isPlaying = true
    }
    
    func pauseAudio() {
        // Pause logic here if needed
        currentAudioPlayer?.pause()
        self.isPlaying = false
    }
}
