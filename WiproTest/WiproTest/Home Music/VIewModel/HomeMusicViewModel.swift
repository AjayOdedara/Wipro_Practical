//
//  HomeViewModel.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation
import UIKit

class HomeMusicViewModel {
    // MARK: - Static Properties

    let reuseIdentifier = "ImageCollectionViewCell"
    let footerIdentifier = "CustomFooterView"
    let itemsPerPage = 30
    let itemsPerRow = 2

    // MARK: - Properties
    var currentPage = 1
    var searchText = ""
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    var searchResultData = Bindable([Album]())
    
    // API INIT
    let appServerClient = AppServerClient.sharedInstance

    func getSearchDataResponse(searchText:String = "") {
        self.searchText =  searchText.isEmpty ? self.searchText : searchText
        showLoadingHud.value = true
        //http://ws.audioscrobbler.com/2.0/?method=album.search&album=believe&api_key=39120ceb7b8d9e96024552295ca1c2d9&format=json&limit=10&page=3
        //http://ws.audioscrobbler.com/2.0/?method=album.search&album=Yo39120ceb7b8d9e96024552295ca1c2d9&format=json&page=1&limit=30
        print(getFormattedURl())
        appServerClient.api(url: getFormattedURl(),
                            param: nil,
                            success: { (response) in
            self.showLoadingHud.value = false
            self.searchResultData.value.append(contentsOf: response)
        }) { ( error) in
            let alert = SingleButtonAlert(title: "Error",
                                          message: error?.localizedDescription ??  "Loading failed, check network connection",
                                          action: AlertAction(buttonTitle: "Ok", handler: {
                print("Alert action clicked")
            }))
            self.onShowError?(alert)
        }
        
    }
    func getFormattedURl() -> String{
        return APIConstants.webService.album + "\(self.searchText)" + APIConstants.API_Keys.lastFM_ApiKey + "&page=\(currentPage)" + "&limit=\(itemsPerPage)"
    }
    

}
