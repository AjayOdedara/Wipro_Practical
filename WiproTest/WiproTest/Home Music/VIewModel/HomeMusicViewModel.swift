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
    let searchBarPlaceHolder = "Search"
    let navTitle = "Album Search"
    
    let reuseIdentifier = "ImageCollectionViewCell"
    let footerIdentifier = "CustomFooterView"
    
    let itemsPerPage = 30
    let itemsPerRow = 3
    let cellPadding: CGFloat = 5
    
    // MARK: - Properties
    var currentPage:Int = 0
    var searchText:String = ""
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    var searchResultData = Bindable([Album]())
    
    // API Service INIT
    let appServerClient = AppServerClient.sharedInstance

    
    /**
      Uss to search the query for Album name.
      Update the collection with bindings on response data.
    
      - Parameter searchText: Takes Album Name - Texts of the search ( Search Query )
    */
    func getSearchDataResponse(searchText:String = "") {
        
        
        currentPage = currentPage + 1 //let currentPage = searchResultData.value.count/viewModel.itemsPerPage
        self.searchText =  searchText.isEmpty ? self.searchText : searchText
        showLoadingHud.value = true
        
        guard let apiUrl = getFormattedURl() else {
            
            let alert = SingleButtonAlert(title: "Error",
                                          message: "Failed to load url for search query:\(searchText)",
                                          action: AlertAction(buttonTitle: "Ok", handler: {
                print("Alert action clicked")
            }))
            currentPage = currentPage - 1
            self.onShowError?(alert)
            return
        }
        
        //API Call
        appServerClient.api(url: apiUrl ,
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
    
    /**
      Use fo encode the url  and return to use for Api call
    */
    func getFormattedURl() -> String? {
        let escapedString = self.searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = APIConstants.webService.album + "\(escapedString)" + APIConstants.API_Keys.lastFM_ApiKey + "&page=\(currentPage)" + "&limit=\(itemsPerPage)"
        return url
    }
    
    /**
      Use to check is last cell index or not.
      if Is last index it will load another page for search query
        
        - Parameter index: Takes the Index of the cell
    */
    func isLastIndex(index:Int) -> Bool {
        return searchResultData.value.count - index == (2 * itemsPerRow)
    }
    
    
    /**
      It will count the cell size for collection view layout.
      Calculation is based on cell padding, view size and Item per row.
    */
    func countCellSizeForIndexPath() -> CGSize {
        let rowPadding = cellPadding * CGFloat( ( itemsPerRow  +  Int(cellPadding) ) - 1)
        let availableSpace = UIWindow().screen.bounds.width - rowPadding
        let itemDimension = availableSpace/CGFloat(itemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension + 60)
    }

}
