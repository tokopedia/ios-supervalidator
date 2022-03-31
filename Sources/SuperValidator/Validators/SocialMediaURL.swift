//
//  SocialMediaURL.swift
//
//
//  Created by alvin.pratama on 24/01/22.
//

import Foundation

extension SuperValidator.Option {
    public enum SocialMediaURL {
        case instagram
        case tiktok
        case youtube
        case twitter

        private var hostWhitelist: SuperValidator.Option.URL.Host {
            switch self {
            case .instagram:
                return [#"(www\.)?(instagram\.com)"#]
            case .tiktok:
                return [#"(vt\.)?(tiktok\.com)"#]
            case .youtube:
                return [#"(www\.)?(youtube\.com)"#]
            case .twitter:
                return [#"(www\.)?(twitter\.com)"#]
            }
        }

        private var paths: SuperValidator.Option.URL.Path {
            switch self {
            case .instagram, .tiktok, .twitter:
                return ["{username}"]
            case .youtube:
                return [
                    "user/{username}",
                    "c/{username}",
                    "id/{username}",
                    "channel/{username}"
                ]
            }
        }

        public var options: SuperValidator.Option.URL {
            .init(
                protocols: ["https", "http"],
                requireProtocol: false,
                requireValidProtocol: true,
                paths: self.paths,
                allowQueryComponents: false,
                hostWhitelist: self.hostWhitelist,
                hostBlacklist: [],
                fqdn: .init()
            )
        }
    }
}
