//
//  File.swift
//  
//
//  Created by christopher.mienarto on 26/04/22.
//

import XCTest

@testable import SuperValidator

internal final class CreditCardValidatorTests: XCTestCase {
    private let validator = SuperValidator.shared
    
    // Valid
    internal func testValidCreditCardVisa() {
        let isVisa = validator.creditCardValidator("4263982640269299", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardVisaWithSeparator() {
        let isVisa = validator.creditCardValidator("4263-9826-4026-9299", options: .init(cardType: .visa, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardMasterCard() {
        let isVisa = validator.creditCardValidator("5425233430109903", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardMasterCardWithSeparator() {
        let isVisa = validator.creditCardValidator("5425-2334-3010-9903", options: .init(cardType: .mastercard, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardAmex() {
        let isVisa = validator.creditCardValidator("3722222222222222", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardAmexWithSeparator() {
        let isVisa = validator.creditCardValidator("3722-2222-2222-2222", options: .init(cardType: .amex, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    // Invalid
    internal func testInvalidCreditCardVisa() {
        let isVisa = validator.creditCardValidator("1263982640269299", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CreditCardError.invalidCard)
        }
    }
    
    internal func testInvalidCreditCardMasterCard() {
        let isVisa = validator.creditCardValidator("5725233430109903", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CreditCardError.invalidCard)
        }
    }
    
    internal func testInvalidCreditCardAmex() {
        let isVisa = validator.creditCardValidator("3622222222222222", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CreditCardError.invalidCard)
        }
    }
}
