//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

public enum PhoneFormat {
    case international
    case nanp
    case epp
}

extension SuperValidator.Option {
    /// Phone
    public struct Phone {
        public let phoneFormatType: PhoneFormat

        public init(
            phoneFormatType: PhoneFormat = .international
        ) {
            self.phoneFormatType = phoneFormatType
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum PhoneErrorType: Error, LocalizedError {
        case displayNameMoreThanLimit
        case specificHost
        case blacklistHost
        case levelDomainHost
        case emailInvalid
        
        public var errorDescription: String? {
            switch self {
            case .displayNameMoreThanLimit, .specificHost, .levelDomainHost, .blacklistHost :
                return nil
            case .emailInvalid:
                return "Invalid Email"
            }
        }
    }
}


extension SuperValidator {
    internal func phoneValidator(_ string: String, options: Option.Phone = .init()) -> Result<Bool, ErrorType> {
        let _string = string
        switch options.phoneFormatType {
        case .international:
            if _string.matchesRegex(Regex.internationalPhoneFormat) {
                return .success(true)
            } else {
                return .failure(ErrorType.phoneInvalid(errorMessage: "invalid international phone format"))
            }
        case .nanp:
            if _string.matchesRegex(Regex.NANPPhoneFormat) {
                return .success(true)
            } else {
                return .failure(ErrorType.phoneInvalid(errorMessage: "invalid nanp phone format"))
            }
        case .epp:
            if _string.matchesRegex(Regex.EPPPhoneFormat) {
                return .success(true)
            } else {
                return .failure(ErrorType.phoneInvalid(errorMessage: "invalid epp phone format"))
            }
        }
    }
}
