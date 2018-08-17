//
//  VideoListTableViewController.swift
//  YYPlayer
//
//  Created by JayKong on 2018/8/15.
//  Copyright © 2018 EF Education. All rights reserved.
//

import AVKit
import UIKit
import MediaPlayer
extension String {
    static var documentPath: String? {
        guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        return docPath
    }
}

#if DEBUG // 1
var signal: DispatchSourceSignal? // 2
private let setupSignalHandlerFor = { (_ object: AnyObject) -> Void in // 3
    let queue = DispatchQueue.main
    signal =
        DispatchSource.makeSignalSource(signal: Int32(SIGSTOP), queue: queue) // 4
    signal?.setEventHandler { // 5
        print("Hi, I am: \(object.description!)")
    }
    signal?.resume() // 6
}
#endif

class VideoListTableViewController: UITableViewController {
    var videoList = [String]()
    var selectedIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        _ = setupSignalHandlerFor(self)
        #endif
        guard let docPath = String.documentPath else { return }
        let contents = try! FileManager.default.subpathsOfDirectory(atPath: docPath)
            .filter({ (path) -> Bool in
                path.hasSuffix(".mp4")
            })
            .sorted()
        videoList = contents
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoListTableViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

//        tableView.estimatedRowHeight = 60
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoItemCell", for: indexPath) as! VideoItemCell
        cell.titleLbl.text = videoList[indexPath.row]
        if let idx = selectedIndex {
            if idx == indexPath.row {
                cell.titleLbl.textColor = UIColor.orange
            } else {
                cell.titleLbl.textColor = UIColor.black
            }
        } else {
            cell.titleLbl.textColor = UIColor.black
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func playAtIndex(_ index: Int) {
        guard let docPath = String.documentPath else { return }
        let url = URL(fileURLWithPath: docPath.appending("/\(videoList[index])"))
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        VideoPlayer.shared.player = player
        VideoPlayer.shared.playerViewController.player = player
        VideoPlayer.shared.playerViewController.player?.play()

        setNowPlayingInfo(videoList[index])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        playAtIndex(indexPath.row)
        
        present(VideoPlayer.shared.playerViewController, animated: false) {
            self.tableView.reloadData()
        }
    }
    
    @objc func finishVideo() {
        if var index = selectedIndex {
            index += 1
            selectedIndex = index
            playAtIndex(index)
        }
    }
}
extension VideoListTableViewController {
    func setNowPlayingInfo(_ title:String) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let title = title
        let artworkData = Data()
        let image = UIImage(data: artworkData) ?? UIImage()
        let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
            image
        })
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
//        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}
