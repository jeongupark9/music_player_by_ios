//
//  MusicHelper.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/17.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import Foundation
import AVFoundation
class MusicHelper : NSObject, AVAudioPlayerDelegate{
    
    static let sharedHelper = MusicHelper()
    var songList : [SongInfo]!
    var songInfo : SongInfo!
    var backgroundMusicPlayer: AVAudioPlayer!
    var isShuffle : Bool = false
    var isRepeat : Bool = false
    var currentPlayNum = 0
    func setinit(songlist : [SongInfo], currentNum : Int){
        self.songList = songlist
        self.currentPlayNum = currentNum
    }
    func setCurrentPlayNum(num : Int){
        self.currentPlayNum = num
    }
    func playBackgroundMusic( isNewMusic : Bool = false){
        
        self.songInfo = self.songList[self.currentPlayNum]
        let url = self.songInfo.songURL
        do {
            backgroundMusicPlayer =  try AVAudioPlayer(contentsOf: url  as URL )
            backgroundMusicPlayer.numberOfLoops = 0
            backgroundMusicPlayer.delegate = self
            if isNewMusic {
                backgroundMusicPlayer.prepareToPlay()
            }
            backgroundMusicPlayer.play()
        }catch{
            print(error)
        }
    }
    func pauseMusic(){
        self.backgroundMusicPlayer.pause()
    }
    func checkisPlaying() -> Bool{
        if self.backgroundMusicPlayer != nil {
            return self.backgroundMusicPlayer.isPlaying
        }else{
            return false
        }
    }
    func getCurrentSongInfo() -> SongInfo {
        return songInfo
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        print("finish")
        stopMusic()
    }
    
    func stopMusic(){
        print("stopMusic isShuffle: \(isShuffle) | isRepeat : \(isRepeat)")
        if isShuffle {
            var isCheck = true
            while(isCheck){
                let changeNum  = Int.random(in: 0 ..< songList.count)
                if currentPlayNum != changeNum {
                    currentPlayNum = changeNum
                    isCheck = false
                }
            }
            print("stopMusic currentPlayNum: \(currentPlayNum) ")
            playBackgroundMusic()
            return
        }
        if isRepeat {
            currentPlayNum += 1
            if currentPlayNum >= songList.count {
                currentPlayNum = 0
            }
            print("stopMusic currentPlayNum: \(currentPlayNum) ")
            playBackgroundMusic()
        }
        
        
    }
    
}
