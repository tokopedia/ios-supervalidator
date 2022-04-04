//
//  FQDN.swift
//
//
//  Created by alvin.pratama on 24/01/22.
//

import Foundation

extension SuperValidator.Option {
    /// Fully Qualified Domain Name
    public struct FQDN {
        /// Top Level Domain
        public let requireTLD: Bool
        public let allowUnderscores: Bool
        public let allowTrailingDot: Bool
        /// Wildcard DNS record
        public let allowWildcard: Bool
        
        /// - Parameters:
        ///    - requireTLD: Top Level Domain
        ///    - allowUnderscores
        ///    - allowTrailingDot
        ///    - allowWildcard:Wildcard DNS record
        public init(
            requireTLD: Bool = true,
            allowUnderscores: Bool = false,
            allowTrailingDot: Bool = false,
            allowWildcard: Bool = false
        ) {
            self.requireTLD = requireTLD
            self.allowUnderscores = allowUnderscores
            self.allowTrailingDot = allowTrailingDot
            self.allowWildcard = allowWildcard
        }
    }
}

extension SuperValidator {
    internal func fqdnValidator(_ string: String, options: Option.FQDN = .init()) -> Bool {
        var _string = string

        // Remove the optional trailing dot before checking validity
        if options.allowTrailingDot, let last = _string.last, last == "." {
            _string = String(_string.dropLast())
        }

        // Remove the optional wildcard before checking validity
        if options.allowWildcard, let indexOfWildcard = _string.range(of: "*."), indexOfWildcard == 0 {
            _string = String(_string.dropFirst(2))
        }

        let parts = _string.components(separatedBy: ".")

        if options.requireTLD {
            guard let tld = parts[safe: parts.count - 1] else { return false }
            // disallow fqdns without tld
            if parts.count < 2 || !tld.matches("([a-z\u{00a1}-\u{ffff}]{2,}|xn[a-z0-9-]{2,})") {
                return false
            }

            // disallow space
            if tld.matches("\\s") {
                return false
            }
        }

        for part in parts {
            var _part = part

            if options.allowUnderscores {
                _part = _part.removeUnderscores()
            }

            if !_part.matches("[a-z\u{00a1}-\u{ffff0}0-9-]+") {
                return false
            }

            // disallow parts starting or ending with hyphen
            if let first = _part.first, let last = _part.last {
                if first == "-" || last == "-" {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}
