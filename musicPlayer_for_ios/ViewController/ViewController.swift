//
//  ViewController.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/14.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import UIKit
import MediaPlayer
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var noAlbumLabel: UILabel!
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
        if let layout = albumCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            let size = CGSize(width:(albumCollectionView!.bounds.width-30)/2, height: 250)
            layout.itemSize = size
        }

        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "")
                DispatchQueue.main.async {
                    if self.albums.count == 0 {
                        self.noAlbumLabel.isHidden = false
                        self.albumCollectionView.isHidden = true
                    }else{
                        self.albumCollectionView.reloadData()
                    }
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MusicHelper.sharedHelper.checkisPlaying() {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AlbumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.setAlbumData(albuminfo: albums[indexPath.row],vc : self)
        return cell
    }
    
    
    
}
class AlbumCell : UICollectionViewCell {
    
    @IBOutlet weak var albumimage : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var artistLable : UILabel!
    var albumInfo : AlbumInfo!
    var viewController : ViewController!
    func setAlbumData(albuminfo : AlbumInfo, vc : ViewController){
        self.albumInfo = albuminfo
        self.viewController = vc
        self.titleLabel.text  =  self.albumInfo.albumTitle
        self.artistLable.text = self.albumInfo.albumArtist
        if let img = self.albumInfo.albumartwork {
            self.albumimage.image = img
        }else{
            self.albumimage.image = UIImage(named: "noartwork.png")
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func clickAlbum(_ sender: Any) {
        let vc = self.viewController.storyboard?.instantiateViewController(withIdentifier: "SongListViewController") as! SongListViewController
        vc.setData(self.albumInfo.songs)
        vc.modalPresentationStyle = .fullScreen
        self.viewController.present(vc, animated: false, completion: nil)
    }
}
