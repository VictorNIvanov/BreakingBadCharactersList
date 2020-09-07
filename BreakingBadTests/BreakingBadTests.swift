//
//  BreakingBadTests.swift
//  BreakingBadTests
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import XCTest
@testable import BreakingBad

class BreakingBadTests: XCTestCase {
    
    var viewControllerUnderTest: BBCharacterList!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "CharacterList") as? BBCharacterList
        
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
        
        loadLocalJSONData()
    }
    
    // test if the tableview exists
    func test_hasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.tableView)
    }
    
    // test if the tableview delegate is set
    func test_tableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.delegate)
    }
    
    // test if the controller conforms to the tableview delegate protocol
    func test_tableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:didSelectRowAt:))))
    }
    
    // test if the datasource is set
    func test_tableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.tableView.dataSource)
    }
    
    // test if the controller conforms to the tableview data source protocol
    func test_tableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.numberOfSections(in:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }

    // test if the tableview has a cell reuse identifier set correctly
    func test_tableViewCellHasReuseIdentifier() {
        
        let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? BBListCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "bblistcell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    
    // Tests specific to the app content
    
    // test if the cells display the correct information
    func test_correctRowName() {
        
        let firstCell: BBListCell = viewControllerUnderTest.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BBListCell
        
        XCTAssertTrue(firstCell.name.text == "Walter White", "Incorrect character name in 1st row")
        
        
        let secondCell: BBListCell = viewControllerUnderTest.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! BBListCell
        
        XCTAssertTrue(secondCell.name.text == "Jesse Pinkman", "Incorrect character name in 2nd row")
        
    }
    
    // test if the search function filters the results correctly
    func test_searchResults() {
        
        viewControllerUnderTest.searchController.searchBar.text = "Jes"
        
        XCTAssertTrue(viewControllerUnderTest.tableView.numberOfRows(inSection: 0) == 1, "Incorrect number of results")
        
        
        let firstCell: BBListCell = viewControllerUnderTest.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BBListCell
        
        XCTAssertTrue(firstCell.name.text == "Jesse Pinkman", "Incorrect character name in 1st row")
        
    }
    
    // test if the filter by season functionallity works correctly
    func test_seasonFilterResults() {
        
        viewControllerUnderTest.searchController.searchBar.text = "Gus"
        
        viewControllerUnderTest.searchBar(viewControllerUnderTest.searchController.searchBar, selectedScopeButtonIndexDidChange: 1)
        
        XCTAssertTrue(viewControllerUnderTest.tableView.numberOfRows(inSection: 0) == 0, "Incorrect number of results - Gus is not present in Season 1")
        
        
        viewControllerUnderTest.searchBar(viewControllerUnderTest.searchController.searchBar, selectedScopeButtonIndexDidChange: 2)
        
        XCTAssertTrue(viewControllerUnderTest.tableView.numberOfRows(inSection: 0) == 1, "Incorrect number of results - Gus should be present in Season 2")
        
        
        let firstCell: BBListCell = viewControllerUnderTest.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! BBListCell
        
        XCTAssertTrue(firstCell.name.text == "Gustavo Fring", "Incorrect character name in 1st row")
        
    }
    


    
    // Load a local JSON copy of the API response and set it to the tableview
    func loadLocalJSONData(){
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "testJSON", ofType: "json") else {
            fatalError("testJSON.json not found")
        }
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert testJSON.json to String")
        }
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Unable to convert testJSON.json to Data")
        }
        
        let mockupCharacters: [BBCharacter] = try! JSONDecoder().decode([BBCharacter].self, from: jsonData)
        XCTAssertNotNil(mockupCharacters)

        viewControllerUnderTest.charactersList = mockupCharacters
        
        viewControllerUnderTest.tableView.reloadData()
        
    }
    
    
}
