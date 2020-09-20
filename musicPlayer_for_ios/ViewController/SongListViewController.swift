//
//  SongListViewController.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/16.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class SongListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var songlistTable: UITableView!
    @IBOutlet weak var playBtn : UIButton!
    @IBOutlet weak var playImg: UIImageView!
    @IBOutlet weak var repeatImg: UIImageView!
    @IBOutlet weak var shuffleImg: UIImageView!
    var appMusicPlayer :MPMusicPlayerController!
    var songs: [SongInfo]!
    var audioPlayer : AVAudioPlayer!
    var clickSongCallback : ((SongInfo)->Void)!
    var musicHelper = MusicHelper.sharedHelper
    func setData(_ songs: [SongInfo]){
        musicHelper.setinit(songlist: songs, currentNum: 0 )
        self.songs = songs
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songlistTable.delegate = self
        songlistTable.dataSource = self
    
        repeatImg.alpha =  musicHelper.isRepeat ? 1 : 0.1
        shuffleImg.alpha =  musicHelper.isShuffle ? 1 : 0.1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SongCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.setSong(song: songs[indexPath.row]) { (song) in
            self.musicHelper.setCurrentPlayNum(num: indexPath.row)
            self.musicHelper.playBackgroundMusic(isNewMusic: true)
            self.showMiniPlayer()
        }
        return cell
    }
    func showMiniPlayer(){
        if musicHelper.checkisPlaying() {
            print("now music is playing")
            let miniPlayerView : MiniPlayerView = Bundle.main.loadNibNamed("MusicViews", owner: nil)?[0] as! MiniPlayerView
            miniPlayerView.setViewController(self)
            if !self.view.subviews.contains(miniPlayerView) {
                self.view.addSubview(miniPlayerView)
                miniPlayerView.frame.size.width = self.view.frame.width
                miniPlayerView.frame.origin.y = self.view.frame.height - 100
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMiniPlayer()
    }
    @IBAction func clickPlay(_ send : UIButton){
        if !musicHelper.checkisPlaying() {
            if musicHelper.backgroundMusicPlayer != nil {
                if musicHelper.backgroundMusicPlayer.currentTime > 0 {
                    musicHelper.backgroundMusicPlayer.play()
                }else{
                    musicHelper.playBackgroundMusic()
                    showMiniPlayer()
                }
            }else{
                musicHelper.playBackgroundMusic()
                showMiniPlayer()
            }
        }
    }
    @IBAction func clickRandomPlay(_ send : UIButton){
        musicHelper.isShuffle = !musicHelper.isShuffle
        shuffleImg.alpha =  musicHelper.isShuffle ? 1 : 0.1

    }
    @IBAction func clickBackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func clickRepeat(_ sender: Any) {
        musicHelper.isRepeat = !musicHelper.isRepeat
        repeatImg.alpha =  musicHelper.isRepeat ? 1 : 0.1
    }
}

class SongCell : UITableViewCell {
    
    @IBOutlet weak var songtitle: UILabel!
    var song : SongInfo!
    var callback : ((SongInfo)->Void)!
    func setSong(song : SongInfo, callback :@escaping ((SongInfo)->Void)){
        self.song = song
        self.songtitle.text  = self.song.songTitle
        self.callback = callback
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func clickAndPlay(_ sender: UIButton) {
        self.callback(song)
        
    }
}
