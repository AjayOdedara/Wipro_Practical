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
    // MARK: - Properties
    // Prepare and get Url
    var apiUrl: String {
        return getFormattedURl()
    }
    var currentPage: Int = 0
    var searchText: String = ""
    // Error Presentors
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    // Api data Bindable
    var searchResultData = Bindable([Album]())
    // API service init
    let appServerClient = AppServerClient.sharedInstance

    /**
     * Uss to search the query for Album name.
     * Update the collection with bindings on response data.
    
     * - Parameter searchText: Takes Album Name - Texts of the search ( Search Query )
    */
    func getSearchDataResponse(searchText: String = "") {
        currentPage += 1 //let currentPage = searchResultData.value.count/viewModel.itemsPerPage
        self.searchText =  searchText.isEmpty ? self.searchText : searchText
        showLoadingHud.value = true
        //API Call
        appServerClient.api(url: apiUrl,
                            success: { (response) in
            self.showLoadingHud.value = false
            self.searchResultData.value.append(contentsOf: response)
        }, failure: { ( error ) in
            // Show Alert
            let alert = SingleButtonAlert(title: SearchAlbumConstant.AlertView.alertTitle,
                                          message: error?.localizedDescription ??  SearchAlbumConstant.AlertView.defaultMessgae,
                                          action: AlertAction(buttonTitle: SearchAlbumConstant.AlertView.alertOkayButtonTitle, handler: {
                print("Alert action clicked")
            }))
            self.onShowError?(alert)
        })
    }
    /**
     * Use to encode the url and return to use for Api call
     */
    func getFormattedURl() -> String {
        let escapedString = self.searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let searchType = APIConstants.WebService.album
        let apiKey = APIConstants.ApiKeys.lastFMApiKey
        let itemsPerPage = SearchAlbumConstant.CollectionView.itemsPerPage
        // Merged Url
        let url = searchType + "\(escapedString)" + apiKey + "&page=\(currentPage)" + "&limit=\(itemsPerPage)"
        return url
    }
    /**
     * Use to check is last cell index or not.
     * If Is last index it will load another page for search query
     
       - Parameter index: Takes the Index of the cell
     */
    func isLastIndex(index: Int) -> Bool {
        return searchResultData.value.count - index == (2 * SearchAlbumConstant.CollectionView.itemsPerRow )
    }
    /**
     * It will count the cell size for collection view layout.
     * Calculation is based on cell padding, view size and Item per row.
     */
    func countCellSizeForIndexPath() -> CGSize {
        let cellPadding = SearchAlbumConstant.CollectionView.cellPadding
        let itemsPerRow = SearchAlbumConstant.CollectionView.itemsPerRow
        let rowPadding = cellPadding * CGFloat( ( itemsPerRow  +  Int(cellPadding) ) - 1)
        let availableSpace = UIWindow().screen.bounds.width - rowPadding
        // Dimension Calculation
        let itemDimension = availableSpace/CGFloat(itemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 60)
    }

}
