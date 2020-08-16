//
//  APIConstant.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

struct APIConstants {
   
    public static let lastFM_AlbumSearch = "http://ws.audioscrobbler.com/2.0/?method="
    
    public struct webService {
        
        public static let url = APIConstants.lastFM_AlbumSearch
        
        //MARK: Current Implementation
        public static let album = APIConstants.webService.url +  "album.search&album="
        
        //MARK: Future Enhancement
        public static let track = APIConstants.webService.url +  "track.search&track="
        public static let artist = APIConstants.webService.url +  "artist.search&artist="
        
    }
    
    public struct API_Keys {
        public static let lastFM_ResponseFormat = "&format=json"
        public static let lastFM_ApiKey = "&api_key=39120ceb7b8d9e96024552295ca1c2d9\(lastFM_ResponseFormat)"
    }
}
