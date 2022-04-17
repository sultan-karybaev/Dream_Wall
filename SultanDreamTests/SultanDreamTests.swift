//
//  SultanDreamTests.swift
//  SultanDreamTests
//
//  Created by Sultan Karybaev on 5/10/21.
//

import XCTest

@testable import SultanDream

class SultanDreamTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        XCTAssertEqual(1, 1)
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testQwe() throws {
        XCTAssertEqual(1, 1)
    }
    
    func testQwefwefwef() throws {
        XCTAssertEqual(14, 14)
        //TextFieldValidationService
    }
    
    func testTextFieldValidationServiceIsValidEmailFalse() throws {
        let service = TextFieldValidationService()
        let testField = UITextField()
        testField.text = "qwrfvegw"
        let isValid = service.isValidEmail(textField: testField)
        XCTAssertFalse(isValid)
    }

    func testTextFieldValidationServiceIsValidEmailTrue() throws {
        let service = TextFieldValidationService()
        let testField = UITextField()
        testField.text = "qwerty@qwerty.com"
        let isValid = service.isValidEmail(textField: testField)
        XCTAssertTrue(isValid)
    }
}
