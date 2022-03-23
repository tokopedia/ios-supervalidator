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
        let isValidInternational = validator.isPhoneValid(phoneInternational, options: .init(phoneFormatType: .international))
        switch isValidInternational {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(_):
                break
        }
       
    }
    
    internal func testValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132"
        let isValidNANP = validator.isPhoneValid(phoneNANP, options: .init(phoneFormatType: .nanp))
        switch isValidNANP {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(_):
                break
        }
    }
    
    internal func testValidPhoneNumberEPP() {
        let phoneEPP = "+44.2087712924"
        let isValidEPP = validator.isPhoneValid(phoneEPP, options: .init(phoneFormatType: .epp))
        switch isValidEPP {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(_):
                break
        }
    }
    
    // Invalid
    internal func testInValidPhoneNumberInternational() {
        let phoneInternational = "+6212312311238918989898989889"
        let isValidInternational = validator.isPhoneValid(phoneInternational, options: .init(phoneFormatType: .international))
        switch isValidInternational {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "invalid international phone format")
                break
        }
    }
    
    internal func testInValidPhoneNumberNANP() {
        let phoneNANP = "(415) 555 0132 1231"
        let isValidNANP = validator.isPhoneValid(phoneNANP, options: .init(phoneFormatType: .nanp))
        switch isValidNANP {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "invalid nanp phone format")
                break
        }
    }
    
    internal func testInValidPhoneNumberEPP() {
        let phoneEPP = "+4423.2087712924"
        let isValidEPP = validator.isPhoneValid(phoneEPP, options: .init(phoneFormatType: .epp))
        switch isValidEPP {
            case .success(let value):
                XCTAssertTrue(value)
                break
            case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "invalid epp phone format")
                break
        }
    }
}
