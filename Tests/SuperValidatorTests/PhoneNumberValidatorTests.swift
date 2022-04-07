//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import XCTest
@testable import SuperValidator

internal final class PhoneNumberValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // Valid
    internal func testValidPhoneNumberInternationalWithoutWhitelist() {
        let phoneInternational = "6289699112312"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneNumberFormatType: .international))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidPhoneNumberInternationalWithSpecifyCountryCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "6289612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneNumberFormatType: .international, whitelistPhoneNumberCountry: [.indonesia], isUsingNationalPrefix: false))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidPhoneNumberInternationalWithBlacklistCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "65896123123"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneNumberFormatType: .international, blacklistPhoneNumberCountry: [.singapore], isUsingNationalPrefix: false))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }

    
    internal func testValidPhoneNumberInternationalWithSpecifyCountryCodeWithUsingNationalPrefix() {
        let phoneInternational = "089612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneNumberFormatType: .international, whitelistPhoneNumberCountry: [.indonesia], isUsingNationalPrefix: true))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidPhoneNumberNANPWithCustomPhoneNumberCountry() {
        let phoneNANP = "(415) 555 0132"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(phoneNumberFormatType: .nanp, whitelistPhoneNumberCountry: [.custom(countryCode: "415", nationalPrefix: nil, maxLength: 16)]))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidPhoneNumberEPP() {
        let phoneEPP = "+44.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(phoneNumberFormatType: .epp))
        switch isValidEPP {
            case .success:
            XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    // Invalid
    internal func testInValidPhoneNumberInternational() {
        let phoneInternational = "+6212312311238918989898989889"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneNumberFormatType: .international))
        switch isValidInternational {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
    
    internal func testInValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132 1231"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(phoneNumberFormatType: .nanp))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
    
    internal func testInValidPhoneNumberEPP() {
        let phoneEPP = "+4423.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(phoneNumberFormatType: .epp))
        switch isValidEPP {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
}
