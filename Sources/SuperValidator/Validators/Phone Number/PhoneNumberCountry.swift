//
//  File.swift
//  
//
//  Created by christopher.mienarto on 07/04/22.
//

import Foundation

public enum PhoneNumberCountry: Equatable {
    case australia
    case brazil
    case india
    case indonesia
    case singapore
    case custom(countryCode: String, nationalPrefix: String?, maxLength: Int?)
    
    internal var countryCode: String {
        switch self {
        case .australia:
            return "61"
        case .brazil:
            return "55"
        case .india:
            return "91"
        case .indonesia:
            return "62"
        case .singapore:
            return "65"
        case let .custom(countryCode, _, _):
            return countryCode
        }
    }
    
    internal var nationalPrefix: String {
        switch self {
        case .australia:
            return "0"
        case .brazil:
            return "0"
        case .india:
            return "0"
        case .indonesia:
            return "0"
        case .singapore:
            return "-"
        case let .custom(_, nationalPrefix, _):
            return nationalPrefix ?? ""
        }
    }
    
    internal var maxLength: Int {
        switch self {
        case .australia:
            return 15
        case .brazil:
            return 10
        case .india:
            return 10
        case .indonesia:
            return 14
        case .singapore:
            return 12
        case let .custom(_, _, maxlLength):
            return maxlLength ?? 15
        }
    }
}
