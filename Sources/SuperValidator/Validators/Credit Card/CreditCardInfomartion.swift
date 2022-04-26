//
//  File.swift
//  
//
//  Created by christopher.mienarto on 26/04/22.
//

import Foundation

public enum CreditCardInformation: Equatable {
    case visa
    case mastercard
    case amex
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
