//
//  SearchAlbumHome.swift
//  WiproTestTests
//
//  Created by Ajay Odedra on 16/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

import XCTest
@testable import WiproTest

class SearchAlbumHomeTests: XCTestCase {

    
    let viewModel:HomeMusicViewModel = HomeMusicViewModel()
    let appServerClient = AppServerClient.sharedInstance
    
    func testSerachAlbumQuery() {

        let expectHandlerCall = XCTestExpectation(description: "Album Search Response")
        
        viewModel.currentPage = 1
        viewModel.searchText = MockData.testSearchQuery
        guard let apiUrl = viewModel.getFormattedURl() else {
            XCTFail()
            return
        }
        
        appServerClient.api(url: apiUrl, success: { (albums) in
            expectHandlerCall.fulfill()
        }) { (error) in
            XCTFail()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectHandlerCall], timeout: 5.0)
    }
    
    func testServiceUrl(){
        let expectHandlerCall = XCTestExpectation(description: "Api url")
        viewModel.searchText = MockData.testSearchQuery
        guard let apiUrl = viewModel.getFormattedURl() else {
            XCTFail()
            return
        }
        expectHandlerCall.fulfill()
        print(expectHandlerCall.description, apiUrl)
    }
    
    func testImageDownloadTask(){
        let expectHandlerCall = XCTestExpectation(description: "Image Loading response")
        let imageView = CacheMemoryImageView()
        let mockUrl = MockData.testImageURL
        
        guard let url = URL(string: mockUrl) else {
            XCTFail()
            return
        }
        imageView.loadImage(atURL: url, placeHolder: true) {
            expectHandlerCall.fulfill()
        }
        wait(for: [expectHandlerCall], timeout: 5.0)
    }

}
