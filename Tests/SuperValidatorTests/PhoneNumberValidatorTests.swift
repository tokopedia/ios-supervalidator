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
    
    /// `Valid
    /// `International
    // options
    // - phoneNumberFormatType: .international
    internal func testValidPhoneNumberInternationalWithoutWhitelist() {
        let phoneInternational = "6289699112312"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    //  Phone Number International with whitelistPhoneNumberCountry
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.indonesia]
    // - by default isAllowNationalPrefix: false
    internal func testValidPhoneNumberInternationalWithSpecifyCountryCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "6289122312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.indonesia]))
        switch isValidInternational {
            case .success:
                XCTAssertTrue(true)
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    //  Phone Number International with NoBlacklistCountryCode
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.singapore]
    // - by default isAllowNationalPrefix: false
    internal func testValidPhoneNumberInternationalWithNoBlacklistCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "62896123123"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, blacklist: [.singapore]))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    //  Phone Number International with WhitelistCountryCode and allowed to use national prefix or country code
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.indonesia]
    // - isAllowNationalPrefix: true
    internal func testValidPhoneNumberInternationalWithSpecifyCountryCodeWithUsingNationalPrefix() {
        let phoneInternational = "6289612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.indonesia], isAllowNationalPrefix: true))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    //  Phone Number International with WhitelistCountryCode and allowed to use national prefix or country code
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.custom(countryCode: "67", nationalPrefix: nil, maxLength: 16)]
    // - by default isAllowNationalPrefix: false
    internal func testValidPhoneNumberInternationalWithCustomPhoneNumberCountryAndUsingNationalPrefix() {
        let phoneInternational = "6789612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.custom(countryCode: "67", nationalPrefix: nil, maxLength: 16)]))
        switch isValidInternational {
            case .success:
                XCTAssertTrue(true)
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    /// `North American Phone
    // Phone Number NAP
    // options
    // - phoneNumberFormatType: .nanp (North American Phone)
    internal func testValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(formatType: .nanp))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    // Phone Number NAP with whitelistPhoneNumberCountry using custom Country
    // options
    // - phoneNumberFormatType: .nanp (North American Phone)
    // - whitelistPhoneNumberCountry: [.custom(countryCode: "415", nationalPrefix: nil, maxLength: 16)]
    internal func testValidPhoneNumberNANPWithCustomPhoneNumberCountry() {
        let phoneNANP = "(415) 555 0132"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(formatType: .nanp, whitelist: [.custom(countryCode: "415", nationalPrefix: nil, maxLength: 16)]))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    /// `European People's Party`
    // Phone Number EPP
    // options
    // - phoneNumberFormatType: .epp (European People's Party)
    internal func testValidPhoneNumberEPP() {
        let phoneEPP = "+44.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(formatType: .epp))
        switch isValidEPP {
            case .success:
            XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    // Phone Number EPP with whitelistPhoneNumberCountry using custom Country
    // options
    // - phoneNumberFormatType: .epp (European People's Party)
    // - whitelistPhoneNumberCountry: [.custom(countryCode: "415", nationalPrefix: nil, maxLength: 16)]
    internal func testValidPhoneNumberEPPWithCustomPhoneNumberCountry() {
        let phoneEPP = "+44.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(formatType: .epp, whitelist: [.custom(countryCode: "+44", nationalPrefix: nil, maxLength: 16)]))
        switch isValidEPP {
            case .success:
            XCTAssertTrue(true)
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    /// `Invalid
    /// `International
    //   Phone Number International
    //   Options
    // - phoneNumberFormatType: .international
    internal func testInValidPhoneNumberInternational() {
        let phoneInternational = "+6212312311238918989898989889"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international))
        switch isValidInternational {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
    //  Phone Number International with whitelistPhoneNumberCountry
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.indonesia]
    // - by default isAllowNationalPrefix: false
    internal func testInvalidPhoneNumberInternationalWithSpecifyCountryCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "6589122312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.indonesia]))
        switch isValidInternational {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case let .failure(error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidCountryCode)
        }
    }
    //  Phone Number International with BlacklistCountryCode
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.singapore]
    // - by default isAllowNationalPrefix: false
    internal func testInvalidPhoneNumberInternationalWithBlacklistCodeWithoutUsingNationalPrefix() {
        let phoneInternational = "65896123123"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, blacklist: [.singapore]))
        switch isValidInternational {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case let .failure(error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.countryBlacklisted)
        }
    }
    //  Phone Number International with WhitelistCountryCode and allowed to use national prefix or country code
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.indonesia]
    // - isAllowNationalPrefix: true
    internal func testInvalidPhoneNumberInternationalWithSpecifyCountryCodeWithUsingNationalPrefix() {
        let phoneInternational = "1289612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.indonesia], isAllowNationalPrefix: true))
        switch isValidInternational {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case let .failure(error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidCountry)
        }
    }
    //  Phone Number International with WhitelistCountryCode and allowed to use national prefix or country code
    //  Options
    // - phoneNumberFormatType: .international
    // - whitelistPhoneNumberCountry: [.custom(countryCode: "67", nationalPrefix: nil, maxLength: 16)]
    // - by default isAllowNationalPrefix: false
    internal func testInvalidPhoneNumberInternationalWithCustomPhoneNumberCountryAndUsingNationalPrefix() {
        let phoneInternational = "6789612312343"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(formatType: .international, whitelist: [.custom(countryCode: "68", nationalPrefix: nil, maxLength: 16)]))
        switch isValidInternational {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case let .failure(error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidCountryCode)
        }
    }
    /// `North American Phone
    internal func testInValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132 1231"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(formatType: .nanp))
        switch isValidNANP {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case .failure(let error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
    /// `European People's Party`
    internal func testInValidPhoneNumberEPP() {
        let phoneEPP = "+4423.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(formatType: .epp))
        switch isValidEPP {
            case .success:
                XCTFail("Expected to be a failure but got a success")
            case .failure(let error):
                XCTAssertEqual(error, SuperValidator.PhoneNumberError.invalidPhoneNumber)
        }
    }
}
