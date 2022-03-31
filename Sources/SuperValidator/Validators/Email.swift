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
        case displayNameMoreThanLimit(errorMessage: String)
        case specificHost(errorMessage: String)
        case blacklistHost(errorMessage: String)
        case levelDomainHost(errorMessage: String)
        case emailInvalid(errorMessage: String)
        
        public var errorDescription: String? {
            switch self {
            case let .displayNameMoreThanLimit(errorMessage):
                return NSLocalizedString(errorMessage, comment: "")

            case let .specificHost(errorMessage):
                return NSLocalizedString(errorMessage, comment: "")

            case let .blacklistHost(errorMessage):
                return NSLocalizedString(errorMessage, comment: "")

            case let .levelDomainHost(errorMessage):
                return NSLocalizedString(errorMessage, comment: "")
            case let .emailInvalid(errorMessage):
                return NSLocalizedString(errorMessage, comment: "")
            }
        }
    }

}


extension SuperValidator {
    internal func validateEmail(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailErrorType> {
        var subStrings = string.components(separatedBy: "@").filter { $0.isNotEmpty }
        
        guard string.matches(Regex.emailStrict) else {
            return .failure(EmailErrorType.emailInvalid(errorMessage: "Invalid Email"))

        // The expected is 2 because there are name and domain
        if subStrings.count < 2 {
            return .failure(EmailErrorType.emailInvalid(errorMessage: "Invalid Email"))
        }
        
        // Default Match
        // ex : teddy@tokopedia.com
            let personalName = subStrings.removeFirst()
            let domain = subStrings.removeLast()
            let domainParts = domain.components(separatedBy: ".").filter { $0.isNotEmpty }
            let hostName = domain.components(separatedBy: ".")[safe: 0]
            let tld = domain.components(separatedBy: ".")[safe: 1]
            
            if domainParts.count < 2 {
                 return .failure(EmailErrorType.emailInvalid(errorMessage: "Invalid Email"))
            }
            
            // Set Personal name Length
            if options.lengthLimitPersonalName != 0 {
                if personalName.count > options.lengthLimitPersonalName {
                        return .failure(.displayNameMoreThanLimit(errorMessage: "Personal name must less than \(options.lengthLimitPersonalName)"))
                }
            }

            // Specific Host
            if options.specificHostList.isNotEmpty{
                var isFound = false
                    if let hostName = hostName {
                        for host in options.specificHostList {
                            if host == hostName {
                                isFound = true
                                break
                            }
                        }
                    }
                if isFound == false {
                    return .failure(.specificHost(errorMessage: "Host is not allowed"))
                }
            }
            
            // Blacklist
            if options.specificHostBlacklist.isNotEmpty, let _ = options.specificHostBlacklist.first(where: {
                $0 == hostName
            }) {
                return .failure(.blacklistHost(errorMessage: "Your host is blacklisted"))
            }
      
            // Top Level Domain
            if options.specificDomainList.isNotEmpty, let _ = options.specificDomainList.first(where: {
                $0 == tld
            }) {
                return .failure(.levelDomainHost(errorMessage: "Your domain is not allowed"))
            }
        }

        return .success(())
    }
}
