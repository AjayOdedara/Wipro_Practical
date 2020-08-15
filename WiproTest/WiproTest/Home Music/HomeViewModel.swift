//
//  HomeViewModel.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel {
    
    let reuseIdentifier = "SearchCell"
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    var responseData = Bindable([MusicData]())
    
    // API INIT
    let appServerClient = AppServerClient.sharedInstance

    func getSeachData() {
        
        showLoadingHud.value = true
        
    }

}
