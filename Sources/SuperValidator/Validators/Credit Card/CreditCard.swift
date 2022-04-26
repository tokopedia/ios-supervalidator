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
}

extension SuperValidator.Option {
    public struct CreditCard {
        public let cardType: CreditCardType
        public let cardInformation: CreditCardInformation
        public let separator: String
        public init(
            cardType: CreditCardType = .visa,
            separator: String = "",
            expiredDate: String = "",
            cardInformation: CreditCardInformation = .visa
        ) {
            self.cardType = cardType
            self.separator = separator
            self.cardInformation = cardInformation
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum CreditCardError: Error, LocalizedError {
        case invalidCard
        case invalidExpiredDate
        case invalidCVV
        public var errorDescription: String? {
            switch self {
                case .invalidCard, .invalidExpiredDate, .invalidCVV:
                    return nil
            }
        }
    }
}

extension SuperValidator {
    internal func creditCardValidator(_ cardNumber: String, expiryDate: String , csc: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
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
        /// Expiry date should less than today
        if expiryDate.toDate() ?? Date() < Date() {
            return .failure(.invalidExpiredDate)
        }
        /// csc length should equal than card type
        if csc.count < options.cardInformation.cardSecurityCodeLength {
            return .failure(.invalidCVV)
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
