//
//  SongQuery.swift
//  musicPlayer_for_ios
//
//  Created by JeongU Park on 2020/09/15.
//  Copyright © 2020 JeongU Park. All rights reserved.
//

import Foundation
import MediaPlayer

struct SongInfo {

    var albumTitle: String
    var artistName: String
    var songTitle:  String

    var songId   :  NSNumber
    var songURL : NSURL
    var trackNum : NSNumber
    var albumartwork : UIImage?
}

struct AlbumInfo {

    var albumTitle: String
    var albumArtist : String
    var albumartwork : UIImage?
    var songs: [SongInfo]
}

class SongQuery {

    func get(songCategory: String) -> [AlbumInfo] {

        var albums: [AlbumInfo] = []
         let albumsQuery: MPMediaQuery
        if songCategory == "Artist" {
            albumsQuery = MPMediaQuery.artists()

        } else if songCategory == "Album" {
            albumsQuery = MPMediaQuery.albums()

        } else {
            albumsQuery = MPMediaQuery.albums()
        }


       // let albumsQuery: MPMediaQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
      //  var album: MPMediaItemCollection
        for album in albumItems {

            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
           // var song: MPMediaItem

            var songs: [SongInfo] = []

            var albumTitle: String = ""
            var albumArtist : String = ""
            var albumartwork : UIImage? = nil

            for song in albumItems {
           
                albumTitle = song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String
                albumArtist = song.value( forProperty: MPMediaItemPropertyArtist ) as! String
                if let artwork: MPMediaItemArtwork = song.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
                    albumartwork = artwork.image(at: CGSize(width: 200, height: 200))
                }
    
                let songInfo: SongInfo = SongInfo(
                    albumTitle: song.value( forProperty: MPMediaItemPropertyAlbumTitle ) as! String,
                    artistName: song.value( forProperty: MPMediaItemPropertyArtist ) as! String,
                    songTitle:  song.value( forProperty: MPMediaItemPropertyTitle ) as! String,
                    songId:     song.value( forProperty: MPMediaItemPropertyPersistentID ) as! NSNumber,
                    songURL:  song.value(forKey: MPMediaItemPropertyAssetURL) as! NSURL,
                    trackNum: song.value(forProperty: MPMediaItemPropertyAlbumTrackCount) as! NSNumber,
                    albumartwork: albumartwork
                )
                songs.append( songInfo )
            }

            let albumInfo: AlbumInfo = AlbumInfo(

                albumTitle: albumTitle,
                albumArtist: albumArtist,
                albumartwork: albumartwork,
                songs: songs
            )

            albums.append( albumInfo )
        }

        return albums

    }

    func getItem( songId: NSNumber ) -> MPMediaItem {

        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )

        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )

        let items: [MPMediaItem] = query.items! as [MPMediaItem]

        return items[items.count - 1]

    }

}
