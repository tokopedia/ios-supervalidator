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
        let result = urlValidator(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    public func validateURL(_ string: String, options: Option.URL = .init()) -> Result<Void, URLError> {
        return urlValidator(string, options: options)
    }

    /// validate url with social media setting
    /// - Parameters:
    ///   - string: url string
    ///   - socialMedia:enum of social media url option
    /// - Returns: if the url matches the social media url options, return true
    public func isURL(_ string: String, socialMedia: Option.SocialMediaURL) -> Bool {
        let result = urlValidator(string, options: socialMedia.options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    public func validateURL(_ string: String, socialMedia: Option.SocialMediaURL) -> Result<Void, URLError> {
        return urlValidator(string, options: socialMedia.options)
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

