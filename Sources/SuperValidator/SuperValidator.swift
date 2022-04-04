//
//  SuperValidator.swift
//
//
//  Created by alvin.pratama on 22/03/22.
//

import Foundation

public class SuperValidator {
    public static var shared = SuperValidator()
    internal init() {}

    // Validator options stored here in extensions
    public struct Option {}

    // MARK: - URL

    /// validate url with custom options
    /// - Parameters:
    ///   - string: url string
    ///   - options: url options such as valid protocols, hostname, path.
    /// - Returns: if the url matches the options, return true
    public func isURL(_ string: String, options: Option.URL = .init()) -> Bool {
        return validateURL(string, options: options)
    }

    /// validate url with social media setting
    /// - Parameters:
    ///   - string: url string
    ///   - socialMedia:enum of social media url option
    /// - Returns: if the url matches the social media url options, return true
    public func isURL(_ string: String, socialMedia: Option.SocialMediaURL) -> Bool {
        return validateURL(string, options: socialMedia.options)
    }

    // MARK: - FQDN

    /// Fully Qualified Domain Name
    /// - Parameters:
    ///   - string: domain in string
    ///   - options: fqdn options
    /// - Returns: if the domain matches the options, return true
    public func isFQDN(_ string: String, options: Option.FQDN = .init()) -> Bool {
        return validateFQDN(string, options: options)
    }
    
    // MARK: - Phone

    /// validate phone
    /// - Parameters:
    ///   - string: phone in string
    ///   - options: phone options
    /// - Returns: the response either .success(()) or let .failure(let error)
    public func validatePhone(_ string: String, options: Option.Phone = .init()) -> Result<Bool, ErrorType> {
        return phoneValidator(string, options: options)
    }
    
    /// validate phone
    /// - Parameters:
    ///   - string: phone in string
    ///   - options: phone options
    /// - Returns: if the phone matches the options, return true
    public func isPhone(_ string: String, options: Option.Phone = .init()) -> Bool {
        let result = validatePhone(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    // MARK: - Email
    
    /// Use this function to custom the error resposne 
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: domain in String
    ///    - options: email options
    /// - Returns: the response either .success(()) or let .failure(let error)
    public func validateEmail(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailError> {
        return emailValidator(string, options: options)
    }
    
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: domain in String
    ///    - options: email options
    /// - Returns: if the domain matches the options, return true
    public func isEmail(_ string: String, options: Option.Email = .init()) -> Bool {
        let result = validateEmail(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
 
}

