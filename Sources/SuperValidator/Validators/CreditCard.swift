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
    /// Disocver
    /// Example: 60115564485789458 || 6500000000000000
    case discover
    
    internal var cardSecurityCodeName: String {
        switch self {
            /// cvv:  card verification value
            case .visa: return "cvv"
            /// cvc: card validation code
            case .mastercard: return "cvc"
            /// cid: card ID
            case .amex: return "cid"
            /// cvd: card verification data
            case .discover: return "cvd"
        }
    }
    internal var cardSecurityCodeLength: Int {
        switch self {
            case .visa, .mastercard, .discover: return 3
            case .amex: return 4
        }
    }
}

extension SuperValidator.Option {
    public struct CreditCard {
        public let cardType: CreditCardType
        public let separator: String
        public init(
            cardType: CreditCardType = .visa,
            separator: String = "",
            expiredDate: String = ""
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
        case invalidExpiredDate
        case invalidCSC
        public var errorDescription: String? {
            switch self {
                case .invalidCard, .invalidExpiredDate, .invalidCSC:
                    return nil
            }
        }
    }
}

extension SuperValidator {
    internal func creditCardNumberValidator(_ cardNumber: String,options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
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
            case .discover:
                guard tempCardNumber.matches(Regex.discover) else {
                    return .failure(.invalidCard)
                }
        }
        return .success(())
    }
    
    internal func creditCardExpiredDateValidator(expiryDate: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        /// Expiry date should less than today
        if expiryDate.toDate() ?? Date() < Date() {
            return .failure(.invalidExpiredDate)
        }
        return .success(())
    }
    
    internal func creditCardCSCValidator(csc: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        /// csc length should equal than card type
        if csc.count != options.cardType.cardSecurityCodeLength {
            return .failure(.invalidCSC)
        }
        return .success(())
    }
}

extension String {
    internal func toDate(withFormat format: String = "MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}
