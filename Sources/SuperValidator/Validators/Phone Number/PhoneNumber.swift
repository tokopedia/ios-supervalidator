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
        public let formatType: PhoneNumberFormat
        public let whitelist: [PhoneNumberCountry]
        public let blacklist: [PhoneNumberCountry]
        public let isAllowNationalPrefix: Bool
        
        public init(
            formatType: PhoneNumberFormat = .international,
            whitelist: [PhoneNumberCountry] = [],
            blacklist: [PhoneNumberCountry] = [],
            isAllowNationalPrefix: Bool = false
        ) {
            self.formatType = formatType
            self.whitelist = whitelist
            self.blacklist = blacklist
            self.isAllowNationalPrefix = isAllowNationalPrefix
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
        case invalidCountry
        
        public var errorDescription: String? {
            switch self {
            case .invalidCountryCode, .invalidPhoneNumber, .invalidNationalPrefix, .invalidMaxLength, .countryBlacklisted, .invalidCountry:
                return nil
            }
        }
    }
}

extension SuperValidator {
    internal func phoneValidator(_ phoneNumber: String, options: Option.PhoneNumber = .init()) -> Result<Void, PhoneNumberError> {
        var countryCode = ""
        var nationalPrefix = ""
        switch options.formatType {
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
            /// `The Data already predefined
            /// ex : whiltelistPhoneNumberCountry : [.indonesia] -> which the country code is 62
            /// Country code is the first character until x index (Based on the country code that already defined)
            /// a. `Using Contains (NOT SATISFY THE REQUIREMENT)
            ///   `The Algorithm behind contains
             /*
              public func contains(
                    where predicate: (Element) throws -> Bool
                  ) rethrows -> Bool {
                    for e in self {
                      if try predicate(e) {
                        return true
                      }
                    }
              return false
          }*/
            ///  phoneNumber = "12062896132323" , expected return false, but return true
            /// b. `Using Prefix (SATISFY THE REQUIREMENT) based on the current country code length
            ///  phoneNumber = "12062896132323", , expected return false, and return false
            ///  phoneNumber = "62896132323123", , expected return true, and return true
            if options.whitelist.isNotEmpty {
                options.whitelist.forEach { phoneNumberCountry in
                    countryCode = String(phoneNumber.prefix(phoneNumberCountry.countryCode.count))
                    nationalPrefix = String(phoneNumber.prefix(phoneNumberCountry.nationalPrefix.count))
                }
            }
            if options.blacklist.isNotEmpty {
                options.blacklist.forEach { phoneNumberCountry in
                    countryCode = String(phoneNumber.prefix(phoneNumberCountry.countryCode.count))
                }
            }
        }
        /// Whitelist Country
        if options.whitelist.isNotEmpty {
            var isFoundPhoneNumberCountryCode = false
            var isFoundPhoneNumberNationalPrefix = false
            var isPhoneNumberLengthValid = true
            options.whitelist.forEach { phoneNumberCountry in
                if phoneNumberCountry.nationalPrefix == nationalPrefix {
                    isFoundPhoneNumberNationalPrefix = true
                }
                if phoneNumberCountry.countryCode == countryCode {
                    isFoundPhoneNumberCountryCode = true
                }
                if phoneNumberCountry.maxLength < phoneNumber.count {
                    isPhoneNumberLengthValid = false
                }
            }
            if options.isAllowNationalPrefix {
                // Expected can receive 0 or 62
                if !isFoundPhoneNumberNationalPrefix && !isFoundPhoneNumberCountryCode{
                    return .failure(.invalidCountry)
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
        /// Blacklist Country
        /// Check based on only the country code because national prefix is not unique
        if options.blacklist.isNotEmpty {
            var isFoundCountryCode = false
            options.blacklist.forEach { phoneNumberCountry in
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

