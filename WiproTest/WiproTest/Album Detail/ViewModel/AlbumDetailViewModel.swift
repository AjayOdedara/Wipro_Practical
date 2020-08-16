//
//  AlbumDetailViewModel.swift
//  WiproTest
//
//  Created by Ajay Odedra on 16/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

class AlbumDetailViewModel{
    
    let loadWithData: Bindable = Bindable(false)
    var album:Album?
    var albumLargeImageUrl:URL?
    init(album:Album) {
        self.album = album
        self.setData()
    }
    
    func setData(){
        self.loadWithData.value = true
    }
    
}
    
