//
//  PoqAppTechUITests.swift
//  PoqAppTechUITests
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import XCTest

final class PoqAppTechUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // This method is called before each test case.
        // It sets up the test environment by creating an instance of the application to be tested.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // This method is called after each test case.
        // It performs the necessary cleanup by resetting the `app` instance to nil.
        app = nil
    }
    
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) {
        // This method waits for an element to appear on the screen within a specified timeout.
        // It uses an expectation and a predicate to evaluate the existence of the element.
        // If the element appears within the given timeout, the expectation is fulfilled.
        // Otherwise, the test case fails.
          let exists = NSPredicate(format: "exists == 1")
          expectation(for: exists, evaluatedWith: element, handler: nil)
          waitForExpectations(timeout: timeout, handler: nil)
      }
    
    func testTableViewDisplay() throws {
        // This is a test case method that verifies the display of a table view.
        // It retrieves the first table view in the application and asserts its existence.
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists, "The table view exists")
    }
    
    func testTableFirstCellExist() throws {
        // This is a test case method that verifies the existence of the first cell in a table view.
        // It retrieves the first table view in the application and the first cell within it.
        // It then waits for the cell to appear on the screen and asserts its existence.
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 0)
        waitForElementToAppear(firstCell)
        XCTAssertTrue(firstCell.exists, "The first cell exists")
    }
    
    func testTableViewCellTap() throws {
        // This is a test case method that verifies the interaction with a table view cell.
        // It retrieves the first table view in the application and the second cell within it.
        // It then waits for the cell to appear on the screen, taps it, and asserts the existence of a detail screen.
        let tableView = app.tables.firstMatch
        let firstCell = tableView.cells.element(boundBy: 1)
        waitForElementToAppear(firstCell)
        firstCell.tap()
        
        let detailTitle = app.staticTexts["Detail Repos"] 
        XCTAssertTrue(detailTitle.exists, "The detail screen is displayed")
    }
}

