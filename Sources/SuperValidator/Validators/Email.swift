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
        public let specificDomainList: [String]
        public let specificHostBlacklist: [String]
        public let specificHostList: [String]

        public init(
            lengthLimitPersonalName: Int = 0,
            specificDomainList: [String] = [],
            hostBlacklist: [String] = [],
            specificHost: [String] = []
        ) {
            self.lengthLimitPersonalName = lengthLimitPersonalName
            self.specificDomainList = specificDomainList
            specificHostBlacklist = hostBlacklist
            specificHostList = specificHost
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
    internal func validateEmail(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailErrorType> {
        var subStrings = string.components(separatedBy: "@").filter { $0.isNotEmpty }
        
        guard string.matches(Regex.emailStrict) else {
            return .failure(EmailErrorType.emailInvalid)
        }
        
        // The expected is 2 because there are name and domain
        if subStrings.count < 2 {
            return .failure(EmailErrorType.emailInvalid)
        }
        
        // Default Match
        // ex : teddy@tokopedia.com
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

            // Specific Host
            if options.specificHostList.isNotEmpty {
                if !options.specificHostList.contains(hostName ?? "") {
                    return .failure(.specificHost)
                }
            }
        
            
            // Blacklist
            if options.specificHostBlacklist.isNotEmpty, let _ = options.specificHostBlacklist.first(where: {
                $0 == hostName
            }) {
                return .failure(.blacklistHost)
            }
      
            // Top Level Domain
            if options.specificDomainList.isNotEmpty {
                if !options.specificDomainList.contains(tld ?? "") {
                    return .failure(.levelDomainHost)
                }
            }
       

        return .success(())
    }
}
