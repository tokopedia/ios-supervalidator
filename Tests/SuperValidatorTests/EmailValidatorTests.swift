//
//  EmailValidatorTest.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import XCTest


@testable import SuperValidator

internal final class EmailValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // Valid
    internal func testValidEmailByPass() {
        let isEmail = self.validator.isEmail("teddy@test.com")
        XCTAssertTrue(isEmail)
    }
    
    
    internal func testValidEmail() {
        let isEmail = self.validator.checkedEmail("teddy@test.com")
        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithPersonalNameLength() {
        let isEmail = self.validator.checkedEmail("teddy@test.com", options: SuperValidator.Option.Email(lengthLimitPersonalName: 8))
        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithSpecificHostName() {
        let isEmail = self.validator.checkedEmail("teddy@test.com", options: SuperValidator.Option.Email(specificHost: ["test", "tost", "tist"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithNotBlackListedHost() {
        let isEmail = self.validator.checkedEmail("teddy@test.com", options: SuperValidator.Option.Email(hostBlacklist: ["tist"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithSpecificTLD() {
        let isEmail = self.validator.checkedEmail("teddy@test.com", options: SuperValidator.Option.Email(specificDomainList: ["id", "com"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case .failure:
            break
        }
    }
    
    // Invalid
    internal func testInvalidEmail() {
        let isEmail = self.validator.checkedEmail("teddy.com")
        switch isEmail {
        case .success:
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Invalid Email")
        }
    }
    
    internal func testValidEmailWithInvalidPersonalNameLength() {
        let isEmail = self.validator.checkedEmail("teddychristopher@test.com", options: SuperValidator.Option.Email(lengthLimitPersonalName: 8))
        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Personal name must less than 8")
        }
    }
    
    internal func testValidEmailWithInvalidHostName() {
        let isEmail = self.validator.checkedEmail("teddy@tast.com", options: SuperValidator.Option.Email(specificHost: ["test", "tist", "tost"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Host is not allowed")
        }
    }
    
    internal func testValidEmailWithHostBlacklisted() {
        let isEmail = self.validator.checkedEmail("teddy@tast.com", options: SuperValidator.Option.Email(hostBlacklist: ["tast"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your host is blacklisted")
        }
    }
    
    internal func testValidEmailWithInvalidTDL() {
        let isEmail = self.validator.checkedEmail("teddy@test.us", options: SuperValidator.Option.Email(specificDomainList: ["id", "com"]))

        switch isEmail {
        case let .success(value):
            XCTAssertNotNil(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your domain is not allowed")
        }
    }
    
    // Combine the options
    internal func testValidEmailWithAllOptionsAndInvalidLength() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["tast"], specificHost: ["test", "tist", "tust"])
        let isEmail = SuperValidator.shared.checkedEmail("teddyyyasad@test.com", options: emailOptionAll)
        switch isEmail {
        case .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Personal name must less than 8")
        }
    }
    
    internal func testValidEmailWithAllOptionsAndInvalidHostName() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["tast"], specificHost: ["test", "tist", "tust"])
        let isEmail = SuperValidator.shared.checkedEmail("teddyd@tost.com", options: emailOptionAll)
        switch isEmail {
        case  .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Host is not allowed")
        }
    }
    
    internal func testValidEmailWithAllOptionsAndInvalidTDL() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["tast"], specificHost: ["test", "tist", "tust"])
        let isEmail = SuperValidator.shared.checkedEmail("teddyd@test.us", options: emailOptionAll)
        switch isEmail {
        case .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your domain is not allowed")
        }
    }
}