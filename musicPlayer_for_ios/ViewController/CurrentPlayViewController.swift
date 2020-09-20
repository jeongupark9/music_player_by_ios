//
//  CurrentPlayViewController.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/19.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
class CurrentPlayViewController : UIViewController{
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var musicProgress: UIProgressView!
    @IBOutlet weak var playAndPauseBtn: UIButton!
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBOutlet weak var musicControlLayout: UIView!
    
    @IBOutlet weak var songTitleLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    let musichelper = MusicHelper.sharedHelper
    let timePlayerSelector:Selector = #selector(updatePlayTime)
    let MAX_VOLUME : Float = 1
    var progressTimer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = musichelper.getCurrentSongInfo().albumartwork {
            artwork.image = img
        }else{
            artwork.image = UIImage(named: "noartwork.png")
        }
        totalTimeLabel.text = convertNSTimeInterval2String(musichelper.backgroundMusicPlayer.duration)
        currentTimeLabel.text = convertNSTimeInterval2String(0)
        songTitleLabel.text = musichelper.songInfo.songTitle
        artistNameLabel.text = musichelper.songInfo.artistName
        let volumContorlY = musicControlLayout.frame.origin.y + 70
        let mpview = MPVolumeView(frame: CGRect(x: 20, y: volumContorlY, width: self.view.frame.width - 80, height: 30))
        self.view.addSubview(mpview)
        if musichelper.isShuffle {
            shuffleBtn.alpha = 1
        }else{
            shuffleBtn.alpha = 0.1
        }
        if musichelper.isRepeat {
            repeatBtn.alpha = 1
        }else{
            repeatBtn.alpha = 0.1
        }
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        
        if musichelper.backgroundMusicPlayer.isPlaying {
            playAndPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else{
            playAndPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
    }

    @IBAction func clickCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @objc func updatePlayTime() {
        musicProgress.progress = Float(musichelper.backgroundMusicPlayer.currentTime/musichelper.backgroundMusicPlayer.duration)
        currentTimeLabel.text = convertNSTimeInterval2String(musichelper.backgroundMusicPlayer.currentTime)
        
        if musichelper.backgroundMusicPlayer.currentTime == 0 {
            musicProgress.progress = 0
            songTitleLabel.text = musichelper.songInfo.songTitle
            artistNameLabel.text = musichelper.songInfo.artistName
            totalTimeLabel.text = convertNSTimeInterval2String(musichelper.backgroundMusicPlayer.duration)
        }
    }
    @IBAction func clickPlayAndPause(_ sender: Any) {
        if musichelper.backgroundMusicPlayer.isPlaying {
            playAndPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            musichelper.backgroundMusicPlayer.pause()
        }else{
            playAndPauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            musichelper.backgroundMusicPlayer.play()
        }
    }
    @IBAction func clikcBackward(_ sender: Any) {
        let currentTime = musichelper.backgroundMusicPlayer.currentTime
        var moveTime = currentTime - 5
        if moveTime < 0 {
            moveTime = 0
        }
        musichelper.backgroundMusicPlayer.currentTime = moveTime
    }
    
    @IBAction func clickForward(_ sender: Any) {
        if musichelper.backgroundMusicPlayer.isPlaying {
            let currentTime = musichelper.backgroundMusicPlayer.currentTime
            let moveTime = currentTime + 20
            if moveTime > musichelper.backgroundMusicPlayer.duration {
                musichelper.backgroundMusicPlayer.stop()
                musichelper.backgroundMusicPlayer.currentTime = 0
                currentTimeLabel.text = convertNSTimeInterval2String(0)
                musicProgress.progress = 0
                playAndPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                musichelper.stopMusic()
                
                songTitleLabel.text = musichelper.songInfo.songTitle
                artistNameLabel.text = musichelper.songInfo.artistName
                totalTimeLabel.text = convertNSTimeInterval2String(musichelper.backgroundMusicPlayer.duration)
                
            }else{
                musichelper.backgroundMusicPlayer.currentTime = moveTime
            }
        }
    }
    @IBAction func clickRepeat(_ sender: Any) {
        musichelper.isRepeat = !musichelper.isRepeat
        repeatBtn.alpha = musichelper.isRepeat ? 1 : 0.1
        if musichelper.isRepeat == false {
            musichelper.isShuffle = false
            shuffleBtn.alpha = musichelper.isShuffle ? 1 : 0.1
        }
    }
    @IBAction func clickShuffle(_ sender: Any) {
        if musichelper.isRepeat {
            musichelper.isShuffle = !musichelper.isShuffle
            shuffleBtn.alpha = musichelper.isShuffle ? 0.1 : 1
        }
    }
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        return strTime
    }
    
    
}
