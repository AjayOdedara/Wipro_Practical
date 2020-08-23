//
//  APIConstant.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

struct APIConstants {
    public static let lastFMAlbumSsearch = "http://ws.audioscrobbler.com/2.0/?method="
    public struct WebService {
        public static let url = APIConstants.lastFMAlbumSsearch
        // MARK: - Current Implementation
        public static let album = APIConstants.WebService.url + "album.search&album="
        // MARK: Future Enhancement
        public static let track = APIConstants.WebService.url +  "track.search&track="
        public static let artist = APIConstants.WebService.url +  "artist.search&artist="
    }
    public struct ApiKeys {
        public static let lastFMResponseFormat = "&format=json"
        public static let lastFMApiKey = "&api_key=39120ceb7b8d9e96024552295ca1c2d9\(lastFMResponseFormat)"
    }
}
