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
    ///   - options: url options such as protocols, domain, path.
    /// - Returns: if the url matches the options, return true
    public func isURL(_ string: String, options: Option.URL = .init()) -> Bool {
        let result = urlValidator(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }

    /// validate url with custom options
    /// - Parameters:
    ///   - string: url string
    ///   - options: url options such as protocols, domain, path.
    /// - Returns: a success void or failure with error enum
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
    
    /// validate url with social media setting
    /// - Parameters:
    ///   - string: url string
    ///   - socialMedia:enum of social media url option
    /// - Returns: a success void or failure with error enum
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
        return fqdnValidator(string, options: options)
    }
    
    // MARK: - Phone

    /// validate phone
    /// - Parameters:
    ///   - string: phone in string
    ///   - options: phone options
    /// - Returns: the response either .success(()) or let .failure(let error)
    public func validatePhone(_ string: String, options: Option.PhoneNumber = .init()) -> Result<Void, PhoneNumberError> {
        return phoneValidator(string, options: options)
    }
    
    /// validate phone
    /// - Parameters:
    ///   - string: phone in string
    ///   - options: phone options
    /// - Returns: if the phone matches the options, return true
    public func isPhoneNumber(_ string: String, options: Option.PhoneNumber = .init()) -> Bool {
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
    
    // MARK: - Credit Card
    
    /// Use this function to custom the error resposne
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card number in String
    ///    - options: credit card  options
    /// - Returns: the response either .success(()) or let .failure(let error)
    public func validateCreditCardNumber(_ string: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        return creditCardValidator(string, options: options)
    }
    
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card number in String
    ///    - options: credit card  options
    /// - Returns: if the domain matches the options, return true
    public func isCreditCardNumber(_ string: String,options: Option.CreditCard = .init()) -> Bool {
        let result = validateCreditCardNumber(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    /// Use this function to custom the error resposne
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card expiry date in String, format MM/YYYY. ex : 03/2010
    ///    - options: credit card  options
    /// - Returns: the response either .success(()) or let .failure(let error)
    /// Input paramt
    public func validateCreditCardExpiredDate(_ string: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        return creditCardExpiredDateValidator(expiryDate: string, options: options)
    }
    
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card expiry date in String, format MM/YYYY. ex : 03/2010
    ///    - options: credit card  options
    /// - Returns: if the domain matches the options, return true
    public func isCreditCardExpiredDate(_ string: String,options: Option.CreditCard = .init()) -> Bool {
        let result = validateCreditCardExpiredDate(string, options: options)
        switch result {
        case .success: return true
        case .failure: return false
        }
    }
    
    /// Use this function to custom the error resposne
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card csc (card security code) in String,
    ///    - options: credit card  options
    /// - Returns: the response either .success(()) or let .failure(let error)
    /// Input paramt
    public func validateCreditCardCSC(_ string: String, options: Option.CreditCard = .init()) -> Result<Void, CreditCardError> {
        return creditCardCSCValidator(csc: string, options: options)
    }
    
    /// Custom Email Validation
    /// - Parameters:
    ///    - string: credit card csc (card security code) in String,
    ///    - options: credit card  options
    /// - Returns: if the domain matches the options, return true
    public func isCreditCardCSC(_ string: String,options: Option.CreditCard = .init()) -> Bool {
        let result = validateCreditCardCSC(string, options: options)
        switch result {
            case .success: return true
            case .failure: return false
        }
    }
 
}

