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
        let isVisa = validator.creditCardNumberValidator("4263982640269299", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    internal func testValidCreditCardVisaWithSeparator() {
        let isVisa = validator.creditCardNumberValidator("4263-9826-4026-9299", options: .init(cardType: .visa, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    internal func testValidCreditCardExpiryDateVisa() {
        let isVisa = validator.creditCardExpiredDateValidator(expiryDate: "12/2023", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardCSCVisa() {
        let isVisa = validator.creditCardCSCValidator(csc: "132", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardMasterCard() {
        let isVisa = validator.creditCardNumberValidator("5425233430109903", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardMasterCardWithSeparator() {
        let isVisa = validator.creditCardNumberValidator("5425-2334-3010-9903", options: .init(cardType: .mastercard, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardExpiryDateMasterCard() {
        let isVisa = validator.creditCardExpiredDateValidator(expiryDate: "12/2023", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardCSCMasterCard() {
        let isVisa = validator.creditCardCSCValidator(csc: "132", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardAmex() {
        let isVisa = validator.creditCardNumberValidator("3722222222222222", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardAmexWithSeparator() {
        let isVisa = validator.creditCardNumberValidator("3722-2222-2222-2222", options: .init(cardType: .amex, separator: "-"))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardExpiryDateAmex() {
        let isVisa = validator.creditCardExpiredDateValidator(expiryDate: "12/2023", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    internal func testValidCreditCardCSCAmex() {
        let isVisa = validator.creditCardCSCValidator(csc: "1422", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        }
    }
    
    
    // Invalid
    internal func testInvalidCreditCardVisa() {
        let isVisa = validator.creditCardNumberValidator("1263982640269299", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardNumberError.invalidCardNumber)
        }
    }
    
    internal func testInvalidCreditCardVisaExpiredDate() {
        let isVisa = validator.creditCardExpiredDateValidator(expiryDate: "03/2021", options: .init(cardType: .visa))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardExpiryDateError.invalidExpiredDate)
        }
    }
    
    internal func testInvalidCreditCardMasterCard() {
        let isVisa = validator.creditCardNumberValidator("5725233430109903", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardNumberError.invalidCardNumber)
        }
    }
    
    internal func testInvalidCreditCardMasterCardExpireDate() {
        let isVisa = validator.creditCardExpiredDateValidator(expiryDate: "02/2018", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardExpiryDateError.invalidExpiredDate)
        }
    }
    
    internal func testInvalidCreditCardMasterCardCSCLength() {
        let isVisa = validator.creditCardCSCValidator(csc: "12", options: .init(cardType: .mastercard))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardCSCError.invalidCSC)
        }
    }
    
    internal func testInvalidCreditCardAmex() {
        let isVisa = validator.creditCardNumberValidator("3622222222222222", options: .init(cardType: .amex))
        switch isVisa {
        case .success:
            XCTFail("Expected to be a failure but got success")
        case .failure(let error):
            XCTAssertEqual(error, SuperValidator.CardNumberError.invalidCardNumber)
        }
    }
}
