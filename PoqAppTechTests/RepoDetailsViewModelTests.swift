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
        // This method is called before each test case.
        // It initializes the `mockNetworkManager`, `testRepo`, and `viewModel` to be used in the test.
        // The `mockNetworkManager` is a mock object that simulates networking behavior.
        // The `testRepo` is a sample repository used for testing.
        // The `viewModel` is the view model being tested, initialized with the `testRepo`.
        mockNetworkManager = MockNetworkManager()
        testRepo = RepoModel(name: "Detail Repos", description: "Test Description", owner: Owner(avatarURL: "https://example.com/avatar.png"))
        viewModel = RepoDetailsViewModel(repo: testRepo, networkManager: mockNetworkManager)
    }
    
    override func tearDownWithError() throws {
        // This method is called after each test case.
        // It performs the necessary cleanup by resetting the `viewModel`, `mockNetworkManager`, and `testRepo` to nil.
        viewModel = nil
        mockNetworkManager = nil
        testRepo = nil
    }
 
    
    func testGetImage_Success() {
        // This is a test case method that verifies the successful retrieval of an image.
        // It creates an expectation to wait for an asynchronous operation to complete.
        let expectation = XCTestExpectation(description: "Image fetched successfully")
        // Set up the mock image for the network manager.
        // In this case, we mock the response with a test image.
        let testImage = UIImage(systemName: "star")
        mockNetworkManager.mockImage = testImage
        // Set up the expectation for the `getImageSuccess` closure in the view model.
        // The closure is called when the image is successfully retrieved.
        // It asserts that the received image matches the expected test image.
        viewModel.getImageSuccess = { image in
            XCTAssertEqual(image, testImage)
            expectation.fulfill()
        }
        // Trigger the getImage method in the view model.
        viewModel.getImage()
        // Wait for the expectation to be fulfilled.
        // This ensures that the `getImageSuccess` closure is called and the assertion is executed.
        wait(for: [expectation], timeout: 1.0)
    }
}
