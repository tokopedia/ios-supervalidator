//
//  URL.swift
//
//
//  Created by alvin.pratama on 24/01/22.
//

import Foundation

extension SuperValidator.Option {
    /// URL Options
    public struct URL {
        public typealias Protocols = [String]
        public typealias Path = String?
        public typealias Host = [String]
        /// valid protocol ( e.g https. http, ftp )
        public let protocols: Protocols
        /// if true, url must have protocol
        public let requireProtocol: Bool
        /// protocol must be the same as one of valid protocol listed in protocols constant
        public let requireValidProtocol: Bool
        /// path ( e.g /user/edit/{userID} )
        public let path: Path
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
            path: Path = nil,
            allowQueryComponents: Bool = true,
            hostWhitelist: Host = [],
            hostBlacklist: Host = [],
            fdqn: FQDN = .init()
        ) {
            self.protocols = protocols
            self.requireProtocol = requireProtocol
            self.requireValidProtocol = requireValidProtocol
            self.path = path
            self.allowQueryComponents = allowQueryComponents
            self.hostWhitelist = hostWhitelist
            self.hostBlacklist = hostBlacklist
            self.fdqn = fdqn
        }
    }
}

extension SuperValidator {
    internal func validateURL(_ string: String, options: Option.URL) -> Bool {
        guard string.isNotEmpty, !string.containsWhitespace else { return false }
        var url = string

        if !options.allowQueryComponents, url.contains("?") || url.contains("&") {
            return false
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
                    return false
                }
            }
        } else if options.requireProtocol {
            return false
        }

        if url.isEmpty { return false }
        url = parts.removeLast()

        parts = url.components(separatedBy: "/")
        url = parts.removeFirst()

        if let path = options.path, !checkPath(parts, path: path) {
            return false
        }

        if url.isEmpty {
            return false
        }

        let hostname = url

        if options.hostWhitelist.isNotEmpty, !checkHost(host: hostname, matches: options.hostWhitelist) {
            return false
        }

        if options.hostBlacklist.isNotEmpty, checkHost(host: hostname, matches: options.hostBlacklist) {
            return false
        }

        if !isFQDN(hostname, options: options.fdqn) {
            return false
        }

        return true
    }

    fileprivate func checkHost(host: String, matches: [String]) -> Bool {
        for match in matches {
            if host == match || host.matches(match) {
                return true
            }
        }
        return false
    }

    fileprivate func checkPath(_ paths: [String], path: String) -> Bool {
        var matches = path.components(separatedBy: "/")

        if let first = matches[safe: 0], first == "" {
            matches.removeFirst()
        }

        if matches.count != paths.count {
            return false
        }

        for i in 0 ..< matches.count {
            if matches[i].contains("{") {
                if paths[i].isEmpty { return false }
                continue
            } else if matches[i] != paths[i] {
                return false
            }
        }
        return true
    }
}
