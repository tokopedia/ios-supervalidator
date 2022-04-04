//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import XCTest

@testable import SuperValidator

internal final class PhoneValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // Valid
    internal func testValidPhoneNumberInternational() {
        let phoneInternational = "+628916123123"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneFormatType: .international, specifiedCountryCode: ["+62"]))
        switch isValidInternational {
        case .success:
                XCTAssertTrue(true)
                break
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
                break
        }
       
    }
    
    internal func testValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(phoneFormatType: .nanp, specifiedCountryCode: ["415"]))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
                break
            case let .failure(error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            break
        }
    }
    
    internal func testValidPhoneNumberEPP() {
        let phoneEPP = "+44.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(phoneFormatType: .epp, specifiedCountryCode: ["+44"]))
        switch isValidEPP {
            case .success:
            XCTAssertTrue(true)
                break
            case let .failure(error):
            XCTFail("Expected to be a success but got a failure with \(error)")
                break
        }
    }
    
    // Invalid
    internal func testInValidPhoneNumberInternational() {
        let phoneInternational = "+6212312311238918989898989889"
        let isValidInternational = validator.validatePhone(phoneInternational, options: .init(phoneFormatType: .international))
        switch isValidInternational {
            case .success:
                XCTAssertTrue(true)
                break
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneError.invalidPhone)
                break
        }
    }
    
    internal func testInValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132 1231"
        let isValidNANP = validator.validatePhone(phoneNANP, options: .init(phoneFormatType: .nanp))
        switch isValidNANP {
            case .success:
                XCTAssertTrue(true)
                break
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneError.invalidPhone)
                break
        }
    }
    
    internal func testInValidPhoneNumberEPP() {
        let phoneEPP = "+4423.2087712924"
        let isValidEPP = validator.validatePhone(phoneEPP, options: .init(phoneFormatType: .epp))
        switch isValidEPP {
            case .success:
                XCTAssertTrue(true)
                break
            case .failure(let error):
            XCTAssertEqual(error, SuperValidator.PhoneError.invalidPhone)
                break
        }
    }
}
