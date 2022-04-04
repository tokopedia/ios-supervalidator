//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

extension SuperValidator.Option {
    /// Email
    public struct Email {
        /// Personal name
        public let lengthLimitLocalPart: Int
        /// Domain
        public let specificDomainWhitelist: [String]
        public let specificDomainBlacklist: [String]

        public init(
            lengthLimitLocalPart: Int = 0,
            specificDomainWhitelist: [String] = [],
            specificDomainBlacklist: [String] = []
        ) {
            self.lengthLimitLocalPart = lengthLimitLocalPart
            self.specificDomainWhitelist = specificDomainWhitelist
            self.specificDomainBlacklist = specificDomainBlacklist
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum EmailError: Error, LocalizedError {
        case lengthLimitLocalPart
        case emailInvalid
        case whitelistDomain
        case blacklistDomain
        
        public var errorDescription: String? {
            switch self {
            case .lengthLimitLocalPart, .whitelistDomain, .blacklistDomain:
                return nil
            case .emailInvalid:
                return "Invalid Email"
            }
        }
    }
}

extension SuperValidator {
    internal func emailValidator(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailError> {
        
        // Default Match
        // ex : teddy@example.com
        var subStrings = string.components(separatedBy: "@").filter { $0.isNotEmpty }
        
        guard string.matches(Regex.emailStrict) else {
            return .failure(EmailError.emailInvalid)
        }
        
        // The expected is 2 because there are name and domain
        if subStrings.count < 2 {
            return .failure(EmailError.emailInvalid)
        }
        
        let personalName = subStrings.removeFirst()
        let domain = subStrings.removeLast()
        let domainParts = domain.components(separatedBy: ".").filter { $0.isNotEmpty }
        
        if domainParts.count < 2 {
             return .failure(EmailError.emailInvalid)
        }
        
        // Set Local Part Length
        // ex : teddy@example.com
        // Local Part : teddy
        if options.lengthLimitLocalPart != 0 {
            if personalName.count > options.lengthLimitLocalPart {
                    return .failure(.lengthLimitLocalPart)
            }
        }
        
        // Whitelist Domain
        // ex : teddy@example.com
        // Domain : example.com
        if options.specificDomainWhitelist.isNotEmpty {
            if !options.specificDomainWhitelist.contains(domain) {
                return .failure(.whitelistDomain)
            }
        }
        
        // Blacklist Domain
        // ex : teddy@example.com
        // Domain : example.com
        if options.specificDomainBlacklist.isNotEmpty, let _ = options.specificDomainBlacklist.first(where: { $0 == domain
        }) {
            return .failure(.blacklistDomain)
        }
    
        return .success(())
    }
}
