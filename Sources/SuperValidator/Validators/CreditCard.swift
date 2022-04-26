//
//  File.swift
//  
//
//  Created by christopher.mienarto on 26/04/22.
//

import Foundation

public enum CreditCardType {
    /// Visa
    /// Example: 4917484589897107
    case visa
    /// Master Card
    /// Example: 5425233430109903
    case mastercard
    /// American Express
    /// Example: 374245455400126
    case amex
}

extension SuperValidator.Option {
    public struct CreditCard {
        public let cardType: CreditCardType
        public let separator: String
        public init(
            cardType: CreditCardType = .visa,
            separator: String = ""
        ) {
            self.cardType = cardType
            self.separator = separator
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum CreditCardError: Error, LocalizedError {
        case invalidCard
        public var errorDescription: String? {
            switch self {
                case .invalidCard:
                    return nil
            }
        }
    }
}

extension SuperValidator {
    internal func creditCardValidator(_ cardNumber: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        var tempCardNumber = cardNumber
        /// Using separator
        if options.separator.isNotEmpty {
           tempCardNumber = ""
            for number in cardNumber.components(separatedBy: options.separator) {
                tempCardNumber += number
            }
        }
        
        switch options.cardType {
        case .visa:
            guard tempCardNumber.matches(Regex.visa) else {
                return .failure(.invalidCard)
            }
        case .mastercard:
            guard tempCardNumber.matches(Regex.masterCard) else {
                return .failure(.invalidCard)
            }
        case .amex:
            guard tempCardNumber.matches(Regex.amex) else {
                return .failure(.invalidCard)
            }
        }
       
        
        return .success(())
    }
}
