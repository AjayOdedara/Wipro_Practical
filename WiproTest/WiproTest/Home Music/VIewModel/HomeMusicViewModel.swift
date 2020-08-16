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
    let itemsPerRow = 3
    let cellPadding: CGFloat = 5
    
    // MARK: - Properties
    var currentPage = 0
    var searchText = ""
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    var searchResultData = Bindable([Album]())
    
    // API INIT
    let appServerClient = AppServerClient.sharedInstance

    func getSearchDataResponse(searchText:String = "") {
        
        //let currentPage = searchResultData.value.count/viewModel.itemsPerPage
        currentPage = currentPage + 1
        self.searchText =  searchText.isEmpty ? self.searchText : searchText
        showLoadingHud.value = true
        
        //API Call
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
        //MARK: ToDo - Endoce
        return APIConstants.webService.album + "\(self.searchText)" + APIConstants.API_Keys.lastFM_ApiKey + "&page=\(currentPage)" + "&limit=\(itemsPerPage)"
    }
    
    func isLastIndex(index:Int)->Bool{
        return searchResultData.value.count - index == (2 * itemsPerRow)
    }
    
    func countCellSizeForIndexPath() -> CGSize{
        let rowPadding = cellPadding * CGFloat( ( itemsPerRow  +  Int(cellPadding) ) - 1)
        let availableSpace = UIWindow().screen.bounds.width - rowPadding
        let itemDimension = availableSpace/CGFloat(itemsPerRow)
        
        return CGSize(width: itemDimension, height: itemDimension + 60)
    }
    

}
