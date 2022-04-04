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
        let isEmail = self.validator.validateEmail("teddy@test.com")
        switch isEmail {
        case .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
            break
        }
    }
    
    internal func testValidEmailWithLocalPartLength() {
        let isEmail = self.validator.validateEmail("teddyyy@test.com", options: SuperValidator.Option.Email(lengthLimitLocalPart: 8))
        switch isEmail {
        case  .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
            break
        }
    }
    
    internal func testValiEmailWithWhitelistDomain() {
        let isEmail = self.validator.validateEmail("teddy@test.com", options: SuperValidator.Option.Email(specificDomainWhitelist: ["test.com", "tast.com", "tist.com"]))
        switch isEmail {
        case  .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
            break
        }
    }
    
    internal func testValiEmailWithNoBlacklistedDomain() {
        let isEmail = self.validator.validateEmail("teddy@tast.com", options: SuperValidator.Option.Email(specificDomainBlacklist: ["test.com"]))
        switch isEmail {
        case  .success:
            XCTAssertTrue(true)
        case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
            break
        }
    }
    
    // Invalid
    internal func testInvalidEmail() {
        let isEmail = self.validator.validateEmail("teddy.com")
        switch isEmail {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.emailInvalid)
        }
    }
    
    internal func testValidEmailWithInvalidLocalPartLength() {
        let isEmail = self.validator.validateEmail("teddychristopher@test.com", options: SuperValidator.Option.Email(lengthLimitLocalPart: 8))
        switch isEmail {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.lengthLimitLocalPart)
        }
    }
    
    internal func testValidEmailWithInvalidWhitelistDomain() {
        let isEmail = self.validator.validateEmail("teddy@tast.com", options: SuperValidator.Option.Email(specificDomainWhitelist: ["test.com", "tist.com", "tost.com"]))
        switch isEmail {
        case  .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.whitelistDomain)
        }
    }
    
    internal func testValidEmailWithBlacklistedDomain() {
        let isEmail = self.validator.validateEmail("teddy@tist.com", options: SuperValidator.Option.Email(specificDomainBlacklist: ["test.com", "tist.com", "tost.com"]))
        switch isEmail {
        case  .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.blacklistDomain)
        }
    }
    
    // Combine the options
    internal func testValidEmailWithAllOptionsAndInvalidLength() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitLocalPart: 8, specificDomainWhitelist: ["test.com", "tist.com", "tust.com"], specificDomainBlacklist: ["tast.com"])
        let isEmail = SuperValidator.shared.validateEmail("teddyyyasad@test.com", options: emailOptionAll)
        switch isEmail {
        case .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.lengthLimitLocalPart)
        }
    }
    
    internal func testValidEmailWithAllOptionsAndNonWhitelistDomain() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitLocalPart: 8, specificDomainWhitelist: ["test.com", "tist.com", "tust.com"], specificDomainBlacklist: ["tast.com"])
        let isEmail = SuperValidator.shared.validateEmail("teddyd@tost.com", options: emailOptionAll)
        switch isEmail {
        case  .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.whitelistDomain)
        }
    }
    
    internal func testValidEmailWithAllOptionsAndBlacklistDomain() {
        let emailOptionAll = SuperValidator.Option.Email(lengthLimitLocalPart: 8, specificDomainBlacklist: ["tast.com"])
        let isEmail = SuperValidator.shared.validateEmail("teddyd@tast.com", options: emailOptionAll)
        switch isEmail {
        case  .success:
            XCTFail("Expected to be a failure but got a success")
        case let .failure(error):
            XCTAssertEqual(error, SuperValidator.EmailError.blacklistDomain)
        }
    }
}
