//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

public enum PhoneNumberFormat {
    /// International Phone
    /// Example: +628969911234
    case international
    /// North American Phone
    /// Example: (415) 555 0132
    case nanp
    /// European People's Party
    /// Example: +44.2087712924
    case epp
}

extension SuperValidator.Option {
    public struct PhoneNumber {
        public let phoneNumberFormatType: PhoneNumberFormat
        public let whitelistPhoneNumberCountry: [PhoneNumberCountry]
        public let blacklistPhoneNumberCountry: [PhoneNumberCountry]
        public let isUsingNationalPrefix: Bool
        
        public init(
            phoneNumberFormatType: PhoneNumberFormat = .international,
            whitelistPhoneNumberCountry: [PhoneNumberCountry] = [],
            blacklistPhoneNumberCountry: [PhoneNumberCountry] = [],
            isUsingNationalPrefix: Bool = false
        ) {
            self.phoneNumberFormatType = phoneNumberFormatType
            self.whitelistPhoneNumberCountry = whitelistPhoneNumberCountry
            self.blacklistPhoneNumberCountry = blacklistPhoneNumberCountry
            self.isUsingNationalPrefix = isUsingNationalPrefix
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum PhoneNumberError: Error, LocalizedError {
        case invalidCountryCode
        case countryBlacklisted
        case invalidPhoneNumber
        case invalidNationalPrefix
        case invalidMaxLength
        
        public var errorDescription: String? {
            switch self {
            case .invalidCountryCode, .invalidPhoneNumber, .invalidNationalPrefix, .invalidMaxLength, .countryBlacklisted:
                return nil
            }
        }
    }
}

extension SuperValidator {
    internal func phoneValidator(_ phoneNumber: String, options: Option.PhoneNumber = .init()) -> Result<Void, PhoneNumberError> {
        var countryCode = ""
        var nationalPrefix = ""
        switch options.phoneNumberFormatType {
        case .nanp:
            guard phoneNumber.matches(Regex.NANPPhoneFormat) else {
                return .failure(.invalidPhoneNumber)
            }
            countryCode = phoneNumber.getCountryCodeNANP()
        case .epp:
            guard phoneNumber.matches(Regex.EPPPhoneFormat) else {
                return .failure(.invalidPhoneNumber)
            }
            countryCode = phoneNumber.getCountryCodeEPP()
        case .international:
            guard phoneNumber.matches(Regex.internationalPhoneFormat) else {
                return .failure(.invalidPhoneNumber)
            }
            if options.whitelistPhoneNumberCountry.isNotEmpty {
                options.whitelistPhoneNumberCountry.forEach { phoneNumberCountry in
                    if phoneNumber.contains(phoneNumberCountry.countryCode) {
                        countryCode = phoneNumberCountry.countryCode
                    }
                    if phoneNumber.contains(phoneNumberCountry.nationalPrefix) {
                        nationalPrefix = phoneNumberCountry.nationalPrefix
                    }
                }
            }
        }
        // Whitelist Country
        if options.whitelistPhoneNumberCountry.isNotEmpty {
            var isFoundPhoneNumberCountryCode = false
            var isFoundPhoneNumberNationalPrefix = false
            var isPhoneNumberLengthValid = true
            options.whitelistPhoneNumberCountry.forEach { phoneNumberCountry in
                // Phone Number National Prefix
                if phoneNumberCountry.nationalPrefix == nationalPrefix {
                    isFoundPhoneNumberNationalPrefix = true
                }
                // Phone Number Country Code
                if phoneNumberCountry.countryCode == countryCode {
                    isFoundPhoneNumberCountryCode = true
                }
                // Phone number max length
                if phoneNumberCountry.maxLength < phoneNumber.count {
                    isPhoneNumberLengthValid = false
                }
            }
            if options.isUsingNationalPrefix {
                if !isFoundPhoneNumberNationalPrefix {
                    return .failure(.invalidNationalPrefix)
                }
                if !isFoundPhoneNumberCountryCode {
                    return .success(())
                }
                if !isPhoneNumberLengthValid {
                    return .failure(.invalidMaxLength)
                }
            } else {
                if !isFoundPhoneNumberCountryCode {
                    return .failure(.invalidCountryCode)
                }
                if !isPhoneNumberLengthValid {
                    return .failure(.invalidMaxLength)
                }
            }
        
        }
        // Blacklist Country
        if options.blacklistPhoneNumberCountry.isNotEmpty {
            var isFoundCountryCode = false
            options.blacklistPhoneNumberCountry.forEach { phoneNumberCountry in
                if phoneNumberCountry.countryCode == countryCode {
                    isFoundCountryCode = true
                }
            }
            if isFoundCountryCode {
                return .failure(.countryBlacklisted)
            }
        }
        return .success(())
    }
}

// MARK: - String Extension to get country code
extension String {
    fileprivate func getCountryCodeNANP() -> String {
        var countryCode = self.stringBefore(")")
        countryCode.removeFirst()
        return countryCode
    }
    
    fileprivate func getCountryCodeEPP() -> String {
        let countryCode = self.stringBefore(".")
        return countryCode
    }
}

