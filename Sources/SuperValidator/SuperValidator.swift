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
    
    // MARK: - Email

    /// Custom Email Validation
    /// - Parameters:
    ///    - string: domain in String
    ///    - options: email options
    /// - Returns: if the domain matches the options, return true
    public func checkedEmail(_ string: String, options: Option.Email = .init()) -> Result<Void, EmailErrorType> {
        return validateEmail(string, options: options)
    }
    
    public func isEmail(_ string: String, options: Option.Email = .init()) -> Bool {
        let result = checkedEmail(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
 
}

