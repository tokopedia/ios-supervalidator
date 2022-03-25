//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

public enum ErrorType: Error {
    case displayNameMoreThanLimit(errorMessage: String)
    case specificHost(errorMessage: String)
    case blacklistHost(errorMessage: String)
    case levelDomainHost(errorMessage: String)
    case emailInvalid(errorMessage: String)
}

extension ErrorType: LocalizedError {
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
