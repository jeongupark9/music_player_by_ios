//
//  MiniPlayerView.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/17.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class MiniPlayerView : RoundedBoarderView {
    
    @IBOutlet weak var musicProgress: UIProgressView!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var songtitle: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var albmImg: UIImageView!
    let timePlayerSelector:Selector = #selector(updatePlayTime)
    var progressTimer : Timer!
    var musicHelper = MusicHelper.sharedHelper
    var viewController : UIViewController!
    func setViewController(_ viewController : UIViewController){
        self.viewController = viewController
    }
    override func awakeFromNib() {
        songtitle.text = musicHelper.getCurrentSongInfo().songTitle
        artist.text = musicHelper.getCurrentSongInfo().artistName
        if let img = musicHelper.getCurrentSongInfo().albumartwork {
            albmImg.image = img
        }else{
            albmImg.image = UIImage(named: "noartwork.png")
        }
        
        musicProgress.progress = 0
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }

    @IBAction func clickPause(_ sender: Any) {
        musicHelper.backgroundMusicPlayer.pause()
    }
    @objc func updatePlayTime() {
        musicProgress.progress = Float(musicHelper.backgroundMusicPlayer.currentTime/musicHelper.backgroundMusicPlayer.duration)
        if musicHelper.backgroundMusicPlayer.currentTime == 0 {
            musicProgress.progress = 0
            songtitle.text = musicHelper.getCurrentSongInfo().songTitle
            artist.text = musicHelper.getCurrentSongInfo().artistName
        }
    }
    @IBAction func clickMiniPlayer(_ sender: Any) {
        print("click MiniPlayer")
        let vc = self.viewController.storyboard?.instantiateViewController(withIdentifier: "CurrentPlayViewController") as! CurrentPlayViewController
        self.viewController.present(vc, animated: true, completion: nil)
        
    }
}

