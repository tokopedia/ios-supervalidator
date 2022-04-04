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
        public let lengthLimitPersonalName: Int
        /// Domain
        public let specificTLDList: [String]
        public let specificDomainHostBlacklist: [String]
        public let specificDomainHostList: [String]

        public init(
            lengthLimitPersonalName: Int = 0,
            specificTLDList: [String] = [],
            specificDomainHostBlacklist: [String] = [],
            specificDomainHostList: [String] = []
        ) {
            self.lengthLimitPersonalName = lengthLimitPersonalName
            self.specificTLDList = specificTLDList
            self.specificDomainHostBlacklist = specificDomainHostBlacklist
            self.specificDomainHostList = specificDomainHostList
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
            
            // Set Personal name Length
            if options.lengthLimitPersonalName != 0 {
                if personalName.count > options.lengthLimitPersonalName {
                        return .failure(.displayNameMoreThanLimit)
                }
            }

            // Specific Domain Host
            // ex : teddy@example.com
            // Domain host : example
            if options.specificDomainHostList.isNotEmpty {
                if !options.specificDomainHostList.contains(hostName ?? "") {
                    return .failure(.specificHost)
                }
            }
        
            
            // Blacklist Domain Host
            // ex : teddy@example.com
            // Domain host : example
            if options.specificDomainHostBlacklist.isNotEmpty, let _ = options.specificDomainHostBlacklist.first(where: {
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
