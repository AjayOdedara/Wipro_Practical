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

    let viewModel: HomeMusicViewModel = HomeMusicViewModel()
    let appServerClient = AppServerClient.sharedInstance
    func testSerachAlbumQuery() {

        let expectHandlerCall = XCTestExpectation(description: "Album Search Response")
        viewModel.currentPage = 1
        viewModel.searchText = MockData.testSearchQuery
        appServerClient.api(url: viewModel.getFormattedURl(), success: { _ in
            expectHandlerCall.fulfill()
        }, failure: { ( error ) in
            let defaultMessgae = NSLocalizedString("album_search_api_failure", comment: "Default api failure message")
            XCTFail("Failed to get response for search string, Reason:\(error?.localizedDescription ??  defaultMessgae)")
        })
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectHandlerCall], timeout: 5.0)
    }
    func testServiceUrl() {
        let expectHandlerCall = XCTestExpectation(description: "Api url")
        viewModel.searchText = MockData.testSearchQuery
        guard let apiUrl = URL(string: viewModel.getFormattedURl()) else {
            XCTFail("Failed to get formatted URL")
            return
        }
        expectHandlerCall.fulfill()
        print(expectHandlerCall.description, apiUrl)
    }
    func testImageDownloadTask() {
        let expectHandlerCall = XCTestExpectation(description: "Image Loading response")
        let imageView = CacheMemoryImageView()
        let mockUrl = MockData.testImageURL
        guard let url = URL(string: mockUrl) else {
            XCTFail("Failed to download the image")
            return
        }
        imageView.loadImage(atURL: url, placeHolder: true) {
            expectHandlerCall.fulfill()
        }
        wait(for: [expectHandlerCall], timeout: 5.0)
    }

}
