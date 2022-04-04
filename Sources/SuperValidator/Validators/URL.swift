//
//  URL.swift
//
//
//  Created by alvin.pratama on 24/01/22.
//

import Foundation

// MARK: - Option

extension SuperValidator.Option {
    /// URL Options
    public struct URL {
        public typealias Protocols = [String]
        public typealias Path = [String]
        public typealias Domain = [String]
        /// valid protocol [https. http, ftp]
        public let protocols: Protocols
        /// if set to true, url must have protocol
        public let requireProtocol: Bool
        /// protocol must be the same as one of the valid protocol listed in protocols parameter
        public let requireValidProtocol: Bool
        /// url path ( e.g /user/edit/{userID} )
        public let paths: Path
        /// if set to true, allow query components ( e.g page=1&sort=asc )
        public let allowQueryComponents: Bool
        /// domain must be the same as one of whitelisted domain
        public let domainWhitelist: Domain
        /// domain can't be the same as one of blacklisted domain
        public let domainBlacklist: Domain
        /// Fully Qualified Domain Name`
        public let fqdn: FQDN
        
        /// - Parameters:
        ///    - protocols: valid protocol [https. http, ftp]
        ///    - requireProtocol: if set to true, url must have protocol
        ///    - requireValidProtocol: protocol must be the same as one of the valid protocol listed in protocols parameter
        ///    - paths: url path ( e.g /user/edit/{userID} )
        ///    - allowQueryComponents: if set to true, allow query components ( e.g page=1&sort=asc )
        ///    - domainWhitelist: domain must be the same as one of whitelisted domain
        ///    - domainBlacklist: domain can't be the same as one of blacklisted domain
        ///    - fqdn: Fully Qualified Domain Name
        public init(
            protocols: Protocols = ["https", "http", "ftp"],
            requireProtocol: Bool = false,
            requireValidProtocol: Bool = true,
            paths: Path = [],
            allowQueryComponents: Bool = true,
            domainWhitelist: Domain = [],
            domainBlacklist: Domain = [],
            fqdn: FQDN = .init()
        ) {
            self.protocols = protocols
            self.requireProtocol = requireProtocol
            self.requireValidProtocol = requireValidProtocol
            self.paths = paths
            self.allowQueryComponents = allowQueryComponents
            self.domainWhitelist = domainWhitelist
            self.domainBlacklist = domainBlacklist
            self.fqdn = fqdn
        }
    }
}

// MARK: - Error

extension SuperValidator {
    public enum URLError: Error, LocalizedError, Equatable {
        case notUrl
        case containsWhitespace
        case containsQueryComponents
        /// protocol not contained in protocols parameter
        case invalidProtocol
        case noProtocol
        case invalidPath
        /// domain not contained in domainWhitelist parameter
        case invalidDomain
        case blacklistedDomain
        case invalidFQDN
        
        public var errorDescription: String? {
            switch self {
            case .notUrl:
                return "Please enter an url"
            case .containsWhitespace, .containsQueryComponents, .invalidProtocol,
                 .noProtocol, .invalidPath, .invalidDomain, .blacklistedDomain,
                 .invalidFQDN:
                return "Please enter a valid url"
            }
        }
    }
}

// MARK: - Validator

extension SuperValidator {
    internal func urlValidator(_ string: String, options: Option.URL) -> Result<Void, URLError> {
        guard string.isNotEmpty else { return .failure(.notUrl) }
        guard !string.containsWhitespace else { return .failure(.containsWhitespace) }
        guard string.matches(Regex.url) else { return .failure(.notUrl) }
        
        var url = string

        if !options.allowQueryComponents, url.contains("?") || url.contains("&") {
            return .failure(.containsQueryComponents)
        }

        // example url https://en.wikipedia.org/wiki/Internet?page=1&p=a#Terminology
        // this will separate #Terminology from url
        // url = https://en.wikipedia.org/wiki/Internet?page=1&p=a
        var parts = url.components(separatedBy: "#")
        url = parts.removeFirst()
        // this will separate ?page=1&p=a from url
        // url = https://en.wikipedia.org/wiki/Internet
        parts = url.components(separatedBy: "?")
        url = parts.removeFirst()
        // this will separate https , en.wikipedia.org/wiki/Internet
        // url = en.wikipedia.org/wiki/Internet
        parts = url.components(separatedBy: "://")

        if parts.count > 1 {
            if let _protocol = parts[safe: 0] {
                if options.requireValidProtocol, !options.protocols.contains(_protocol) {
                    return .failure(.invalidProtocol)
                }
            }
        } else if options.requireProtocol {
            return .failure(.noProtocol)
        }

        if url.isEmpty { return .failure(.notUrl) }
        url = parts.removeLast()

        parts = url.components(separatedBy: "/")
        url = parts.removeFirst()
        
        let pathOptions = options.paths
        if pathOptions.isNotEmpty, !checkPath(parts, options: pathOptions) {
            return .failure(.invalidPath)
        }

        if url.isEmpty {
            return .failure(.notUrl)
        }

        let domain = url

        if options.domainWhitelist.isNotEmpty, !checkDomain(domain, matches: options.domainWhitelist) {
            return .failure(.invalidDomain)
        }

        if options.domainBlacklist.isNotEmpty, checkDomain(domain, matches: options.domainBlacklist) {
            return .failure(.blacklistedDomain)
        }
        
        if !isFQDN(domain, options: options.fqdn) {
            return .failure(.invalidFQDN)
        }

        return .success(())
    }
    
    // MARK: - Check Domain

    fileprivate func checkDomain(_ domain: String, matches: [String]) -> Bool {
        for match in matches {
            if domain == match || domain.matches(match) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Check Path
    
    fileprivate enum PathType {
        case fixed(String)
        case value(String)
        // TODO: Add Regex Case
    }
    
    fileprivate func checkPath(_ parts: [String], options: [String]) -> Bool {
        guard parts.isNotEmpty, parts[0].isNotEmpty else { return false }
        
        let converted = convertPathOptionsToPathType(options)
        
        // match separated count with registered paths
        let possibleValid = converted.filter { $0.count == parts.count }
        if possibleValid.isEmpty { return false }
        
        var matchExists: Bool = false
        for possible in possibleValid {
            matchExists = true
            for i in 0..<possible.count {
                if case let .fixed(key) = possible[i] {
                    if parts[i] != key {
                        matchExists = false
                        break
                    }
                } else if case .value = possible[i] {
                    if parts[i].isEmpty {
                        matchExists = false
                        break
                    }
                }
            }
            if matchExists { return true }
        }
        return matchExists
    }
    
    fileprivate func convertPathOptionsToPathType(_ options: [String]) -> [[PathType]] {
        return options.map { path -> [PathType] in
            let parts = path.split(separator: "/")
            return parts.map { str -> PathType in
                if str.first == "{" {
                    var temp = str
                    temp.removeFirst()
                    temp.removeLast()
                    return .value(String(temp))
                }
                return .fixed(String(str))
            }
        }
    }
}
