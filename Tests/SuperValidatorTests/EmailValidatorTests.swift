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
    internal func testValidEmail() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.com")
        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case .failure:

            break
        }
    }
    
    internal func testValidEmailWithPersonalNameLength() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.com", options: SuperValidator.Option.Email(lengthLimitPersonalName: 8))
        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithSpecificHostName() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.com", options: SuperValidator.Option.Email(specificHost: ["tokopedia", "goto", "gojek"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithNotBlackListedHost() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.com", options: SuperValidator.Option.Email(hostBlacklist: ["shopee"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case .failure:
            break
        }
    }
    
    internal func testValidEmailWithSpecificTDL() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.com", options: SuperValidator.Option.Email(specificDomainList: ["id", "com"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case .failure:
            break
        }
    }
    
    // Invalid
    internal func testInvalidEmail() {
        let isEmail = self.validator.isEmail("teddy.com")
        switch isEmail {
        case .success:
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Invalid Email")
        }
    }
    
    internal func testValidEmailWithInvalidPersonalNameLength() {
        let isEmail = self.validator.isEmail("teddychristopher@tokopedia.com", options: SuperValidator.Option.Email(lengthLimitPersonalName: 8))
        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Personal name must less than 8")
        }
    }
    
    internal func testValidEmailWithInvalidHostName() {
        let isEmail = self.validator.isEmail("teddy@shopee.com", options: SuperValidator.Option.Email(specificHost: ["tokopedia", "goto", "gojek"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Host is not allowed")
        }
    }
    
    internal func testValidEmailWithHostBlacklisted() {
        let isEmail = self.validator.isEmail("teddy@shopee.com", options: SuperValidator.Option.Email(hostBlacklist: ["shopee"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your host is blacklisted")
        }
    }
    
    internal func testValidEmailWithInvalidTDL() {
        let isEmail = self.validator.isEmail("teddy@tokopedia.us", options: SuperValidator.Option.Email(specificDomainList: ["id", "com"]))

        switch isEmail {
        case let .success(value):
            XCTAssertTrue(value)
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your domain is not allowed")
        }
    }
    
    // Combine the options
    internal func testValidEmailWithAllOptionsAndInvalidLength() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["shopee"], specificHost: ["tokopedia", "goto", "gojek"])
        let isEmail = SuperValidator.shared.isEmail("teddyyyasad@tokopedia.com", options: emailOptionAll)
        switch isEmail {
        case .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Personal name must less than 8")
        }
    }
    
    internal func testValidEmailWithAllOptionsAndInvalidHostName() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["bukalapak"], specificHost: ["tokopedia", "goto", "gojek"])
        let isEmail = SuperValidator.shared.isEmail("teddyd@shopee.com", options: emailOptionAll)
        switch isEmail {
        case  .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Host is not allowed")
        }
    }
    
    internal func testValidEmailWithAllOptionsAndInvalidTDL() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitPersonalName: 8, specificDomainList: ["com", "id"], hostBlacklist: ["shopee"], specificHost: ["tokopedia", "goto", "gojek"])
        let isEmail = SuperValidator.shared.isEmail("teddyd@goto.us", options: emailOptionAll)
        switch isEmail {
        case .success(_):
            break
        case let .failure(error):
            XCTAssertEqual(error.localizedDescription, "Your domain is not allowed")
        }
    }
}
