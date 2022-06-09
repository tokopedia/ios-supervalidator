//
//  File.swift
//  
//
//  Created by christopher.mienarto on 09/06/22.
//

import Foundation
#if !os(macOS)
import UIKit

enum CreditCardOption {
    case cardNumber
    case cardExpiryDate
    case cardCSV
}

enum Validator {
    case email
    case url
    case creditCard(CreditCardOption)
    case phoneNumber
}

class SuperValidatorTextField: UITextField {
    var textEdited: ((String) -> Void)? = nil
    var textError: ((String) -> Void)? = nil
    var superValidator = SuperValidator.shared
    
    func bind(textCompletion: @escaping (String) -> Void, textErrorCompletion: @escaping (String) -> Void, validator: Validator) {
        textEdited = textCompletion
        textError = textErrorCompletion
        switch validator {
            case .email:
                addTarget(self, action: #selector(textFieldDidChangedForEmail(_:)), for: .editingChanged)
            case .url:
                addTarget(self, action: #selector(textFieldDidChangedForURL(_:)), for: .editingChanged)
            case .creditCard(let creditCardOption):
                switch creditCardOption {
                    case .cardNumber:
                        addTarget(self, action: #selector(textFieldDidChangedForCreditCardNumber(_:)), for: .editingChanged)
                    case .cardExpiryDate:
                        addTarget(self, action: #selector(textFieldDidChangedForCreditCardExpiryDate(_:)), for: .editingChanged)
                    case .cardCSV:
                        addTarget(self, action: #selector(textFieldDidChangedForCreditCardCSC(_:)), for: .editingChanged)
                    }
            case .phoneNumber:
                addTarget(self, action: #selector(textFieldDidChangedForPhoneNumber(_:)), for: .editingChanged)
        }
    }
    
    // MARK: Email
    
    @objc func textFieldDidChangedForEmail(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validateEmail(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
    // MARK: URL
    
    @objc func textFieldDidChangedForURL(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validateURL(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
    // MARK: Phone Number
    
    @objc func textFieldDidChangedForPhoneNumber(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validatePhone(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
    // MARK: Credit Card
    
    @objc func textFieldDidChangedForCreditCardNumber(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validateCreditCardNumber(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
    @objc func textFieldDidChangedForCreditCardExpiryDate(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validateCreditCardExpiredDate(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
    @objc func textFieldDidChangedForCreditCardCSC(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textEdited?(text)
        let result = superValidator.validateCreditCardCSC(text)
        switch result {
        case .success():
            textError?("")
        case .failure(let error):
            textError?(error.localizedDescription)
        }
    }
    
}

#endif
