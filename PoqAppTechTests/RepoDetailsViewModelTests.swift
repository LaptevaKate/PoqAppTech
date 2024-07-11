//
//  RepoDetailsViewModelTests.swift
//  PoqAppTechTests
//
//  Created by Екатерина Лаптева on 11.07.24.
//

import XCTest
@testable import PoqAppTech

final class RepoDetailsViewModelTests: XCTestCase {
    
    var viewModel: RepoDetailsViewModel!
    var mockNetworkManager: MockNetworkManager!
    var testRepo: RepoModel!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        testRepo = RepoModel(name: "Detail Repos", description: "Test Description", owner: Owner(avatarURL: "https://example.com/avatar.png"))
        viewModel = RepoDetailsViewModel(repo: testRepo, networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
        testRepo = nil
    }
 
    
    func testGetImage_Success() {
        let expectation = XCTestExpectation(description: "Image fetched successfully")
        let testImage = UIImage(systemName: "star")
        mockNetworkManager.mockImage = testImage
        
        viewModel.getImageSuccess = { image in
            XCTAssertEqual(image, testImage)
            expectation.fulfill()
        }
        
        viewModel.getImage()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
