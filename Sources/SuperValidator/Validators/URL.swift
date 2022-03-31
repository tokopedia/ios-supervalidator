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
        public typealias Host = [String]
        /// valid protocol ( e.g https. http, ftp )
        public let protocols: Protocols
        /// if true, url must have protocol
        public let requireProtocol: Bool
        /// protocol must be the same as one of valid protocol listed in protocols constant
        public let requireValidProtocol: Bool
        /// path ( e.g /user/edit/{userID} )
        public let paths: Path
        /// query ( e.g page=1&sort=asc )
        public let allowQueryComponents: Bool
        /// hostname must be the same as one of whitelisted host
        public let hostWhitelist: Host
        /// hostname can't be the same as one of blacklisted host
        public let hostBlacklist: Host
        /// Fully Qualified Domain Name`
        public let fdqn: FQDN

        public init(
            protocols: Protocols = ["https", "http", "ftp"],
            requireProtocol: Bool = false,
            requireValidProtocol: Bool = true,
            paths: Path = [],
            allowQueryComponents: Bool = true,
            hostWhitelist: Host = [],
            hostBlacklist: Host = [],
            fdqn: FQDN = .init()
        ) {
            self.protocols = protocols
            self.requireProtocol = requireProtocol
            self.requireValidProtocol = requireValidProtocol
            self.paths = paths
            self.allowQueryComponents = allowQueryComponents
            self.hostWhitelist = hostWhitelist
            self.hostBlacklist = hostBlacklist
            self.fdqn = fdqn
        }
    }
}

// MARK: - Error

extension SuperValidator {
    public enum URLError: Error, LocalizedError {
        case notUrl
        case containsWhitespace
        case containsQueryComponents
        case invalidProtocol
        case noProtocol
        case invalidPath
        case invalidHost
        case blacklistedHost
        
        public var errorDescription: String? {
            switch self {
            case .notUrl:
                return "Please enter an url"
            case .containsWhitespace, .containsQueryComponents, .invalidProtocol,
                 .noProtocol, .invalidPath, .invalidHost, .blacklistedHost:
                return nil
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

        let hostname = url

        if options.hostWhitelist.isNotEmpty, !checkHost(host: hostname, matches: options.hostWhitelist) {
            return .failure(.invalidHost)
        }

        if options.hostBlacklist.isNotEmpty, checkHost(host: hostname, matches: options.hostBlacklist) {
            return .failure(.blacklistedHost)
        }

        if !isFQDN(hostname, options: options.fdqn) {
            // TODO: Create FQDN Error Reasons
            return .failure(.notUrl)
        }

        return .success(())
    }
    
    // MARK: - Check Host

    fileprivate func checkHost(host: String, matches: [String]) -> Bool {
        for match in matches {
            if host == match || host.matches(match) {
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
