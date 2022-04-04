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
        public let specificTLDList: [String]
        public let specificDomainNameBlacklist: [String]
        public let specificDomainNameList: [String]

        public init(
            lengthLimitLocalPart: Int = 0,
            specificTLDList: [String] = [],
            specificDomainNameBlacklist: [String] = [],
            specificDomainNameList: [String] = []
        ) {
            self.lengthLimitLocalPart = lengthLimitLocalPart
            self.specificTLDList = specificTLDList
            self.specificDomainNameBlacklist = specificDomainNameBlacklist
            self.specificDomainNameList = specificDomainNameList
        }
    }
}

// MARK: - Error
extension SuperValidator {
    public enum EmailErrorType: Error, LocalizedError {
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
    internal func emailValidator(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailErrorType> {
        
        // Default Match
        // ex : teddy@example.com
        var subStrings = string.components(separatedBy: "@").filter { $0.isNotEmpty }
        
        guard string.matches(Regex.emailStrict) else {
            return .failure(EmailErrorType.emailInvalid)
        }
        
        // The expected is 2 because there are name and domain
        if subStrings.count < 2 {
            return .failure(EmailErrorType.emailInvalid)
        }
        
            let personalName = subStrings.removeFirst()
            let domain = subStrings.removeLast()
            let domainParts = domain.components(separatedBy: ".").filter { $0.isNotEmpty }
            let hostName = domain.components(separatedBy: ".")[safe: 0]
            let tld = domain.components(separatedBy: ".")[safe: 1]
            
            if domainParts.count < 2 {
                 return .failure(EmailErrorType.emailInvalid)
            }
            
            // Set Local Part Length
            // ex : teddy@example.com
            // Local Part : teddy
            if options.lengthLimitLocalPart != 0 {
                if personalName.count > options.lengthLimitLocalPart {
                        return .failure(.displayNameMoreThanLimit)
                }
            }

            // Specific Domain Host
            // ex : teddy@example.com
            // Domain host : example
            if options.specificDomainNameList.isNotEmpty {
                if !options.specificDomainNameList.contains(hostName ?? "") {
                    return .failure(.specificHost)
                }
            }
        
            
            // Blacklist Domain Host
            // ex : teddy@example.com
            // Domain host : example
            if options.specificDomainNameBlacklist.isNotEmpty, let _ = options.specificDomainNameBlacklist.first(where: {
                $0 == hostName
            }) {
                return .failure(.blacklistHost)
            }
      
            // Top Level Domain
            // ex : teddy@example.com
            // Top Level Domain : .com
            if options.specificTLDList.isNotEmpty {
                if !options.specificTLDList.contains(tld ?? "") {
                    return .failure(.levelDomainHost)
                }
            }
       

        return .success(())
    }
}
