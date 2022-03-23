//
//  File.swift
//  
//
//  Created by christopher.mienarto on 23/03/22.
//

import Foundation

public enum ErrorType: Error {
     case displayNameMoreThanLimit(errMessage: String)
     case specificHost(errMessage: String)
     case blacklistHost(errMessgea: String)
     case blacklistHost(errMessage: String)
     case levelDomainHost(errMessage: String)
     case emailInvalid(errorMessage: String)
     case phoneInvalid(errorMessage: String)
 }

extension ErrorType: LocalizedError {
     public var errorDescription: String? {
         switch self {
         case let .displayNameMoreThanLimit(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         case let .specificHost(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         case let .blacklistHost(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         case let .levelDomainHost(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         case let .emailInvalid(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         case let .phoneInvalid(errMessage):
             return NSLocalizedString(errMessage, comment: "")
         }
     }
 }
