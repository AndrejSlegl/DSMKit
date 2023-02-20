//
//  AudioStation.swift
//  DSMKit
//

import Foundation

public enum AudioStation: Namespace {
    public enum Playlist: MethodContainer {
        public static func getPlaylists() -> BasicRequestInfo<PlaylistsResponse> {
            return BasicRequestInfo<PlaylistsResponse>(api: api, method: "list", versions: 1...3) { encoder in
                encoder["library"] = "all"
                encoder["limit"] = 5000
                encoder["offset"] = 0
            }
        }
        
        public static func getPlaylist(id: String) -> BasicRequestInfo<PlaylistsResponse> {
            return BasicRequestInfo<PlaylistsResponse>(api: api, method: "getinfo", versions: 1...3) { encoder in
                encoder["id"] = id
                encoder["additional"] = "songs,songs_song_tag,songs_song_audio,songs_song_rating"
                encoder["library"] = "all"
                encoder["songs_limit"] = 5000
                encoder["songs_offset"] = 0
            }
        }
    }
    
    public enum Stream: MethodContainer {
        public static func stream(id: String, seekPos: Int = 0) -> VanillaRequestInfo {
            return VanillaRequestInfo(api: api, versions: 1...3) {
                $0["id"] = id
                $0["seek_position"] = seekPos
            }
        }
    }
}

public struct DSMAudioError: DSMError {
    public typealias BaseError = DSMAudioError
    public let rawValue: Int
    public init?(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct PlaylistsResponse: Decodable, ErrorInfo {
    public typealias ErrorType = DSMAudioError
    public let playlists: [DSMPlaylist]
}

public struct DSMSong: Decodable {
    public struct Tag: Decodable {
        public let album: String?
        public let album_artist: String?
        public let artist: String?
        public let comment: String?
        public let composer: String?
        public let disc: Int?
        public let genre: String?
        public let track: Int?
        public let year: Int?
    }
    
    public struct Rating: Decodable {
        public let rating: Int
    }
    
    public struct Additional: Decodable {
        public let song_tag: Tag?
        public let song_rating: Rating?
    }
    
    public let id: String
    public let path: String
    public let title: String
    public let type: String
    public let additional: Additional?
}

public struct DSMPlaylist: Decodable {
    public struct Additional: Decodable {
        public let songs: [DSMSong]
    }
    
    public let id: String
    public let library: String?
    public let name: String
    public let type: String
    public let path: String?
    public var additional: Additional?
}
