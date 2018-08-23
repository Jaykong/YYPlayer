//
//  VideoPlayer.swift
//  YYPlayer
//
//  Created by JayKong on 2018/8/15.
//  Copyright © 2018 EF Education. All rights reserved.
//

import AVKit
import MediaPlayer
import UIKit
class VideoPlayer {
    static let shared = VideoPlayer()
    private init() {}
    
    var player: AVPlayer! {
        didSet {
            setupRemoteTransportControls()
        }
    }

    let playerViewController: AVPlayerViewController = {
        let pv = AVPlayerViewController()
        pv.updatesNowPlayingInfoCenter = false
        return pv
    }()

    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()

        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }

        commandCenter.togglePlayPauseCommand.addTarget { [unowned self] _ in

            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            } else {
                self.player.pause()
                return .success
            }
        }
    }
}
