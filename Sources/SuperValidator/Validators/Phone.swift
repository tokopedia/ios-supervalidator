//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

public enum PhoneFormat {
    // International Phone
    case international
    // North American Phone
    case nanp
    // European People's Party
    case epp
}

extension SuperValidator.Option {
    /// Phone
    public struct Phone {
        public let phoneFormatType: PhoneFormat
        public let specifiedCountryCode: [String]

        public init(
            phoneFormatType: PhoneFormat = .international,
            specifiedCountryCode: [String] = []
        ) {
            self.phoneFormatType = phoneFormatType
            self.specifiedCountryCode = specifiedCountryCode
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum PhoneError: Error, LocalizedError {
        case invalidCountryCode
        case invalidPhone
        
        public var errorDescription: String? {
            switch self {
            case .invalidCountryCode:
                return nil
            case .invalidPhone:
                return "Invalid Phone number"
            }
        }
    }
}


extension SuperValidator {
    internal func phoneValidator(_ string: String, options: Option.Phone = .init()) -> Result<Void, PhoneError> {
        switch options.phoneFormatType {
        case .international:
            guard string.matches(Regex.internationalPhoneFormat) else {
                return .failure(PhoneError.invalidPhone)
            }
            
            let phoneCode = string.prefix(3)
            if options.specifiedCountryCode.isNotEmpty {
                if !options.specifiedCountryCode.contains(String(phoneCode)) {
                    return .failure(.invalidCountryCode)
                }
            }
            
            
        case .nanp:
            guard string.matches(Regex.NANPPhoneFormat) else {
                return .failure(PhoneError.invalidPhone)
            }
            
            let countryCode = string.getCountryCodeNANP()
            if options.specifiedCountryCode.isNotEmpty {
                if !options.specifiedCountryCode.contains(countryCode) {
                    return .failure(.invalidCountryCode)
                }
            }
        
        case .epp:
            guard string.matches(Regex.EPPPhoneFormat) else {
                return .failure(PhoneError.invalidPhone)
            }
            let countryCode = string.getCountryCodeEPP()
            if options.specifiedCountryCode.isNotEmpty {
                if !options.specifiedCountryCode.contains(countryCode) {
                    return .failure(.invalidCountryCode)
                }
            }
        }
        return .success(())
    }
}
