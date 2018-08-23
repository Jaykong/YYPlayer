//
//  AppDelegate.swift
//  YYPlayer
//
//  Created by JayKong on 2018/8/15.
//  Copyright © 2018 EF Education. All rights reserved.
//

import AVFoundation
import AVKit
import MediaPlayer
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print(error)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        application.beginReceivingRemoteControlEvents()
        return true
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeInt = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeInt) else {
            return
        }
        switch type {
        case .began:
            // Pause your player
            print("pause")
            VideoPlayer.shared.player.pause()

        case .ended:
            if let optionInt = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionInt)
                if options.contains(.shouldResume) {
                    // Resume your player
                    VideoPlayer.shared.player.play()
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        VideoPlayer.shared.playerViewController.player = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        VideoPlayer.shared.playerViewController.player = VideoPlayer.shared.player
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
