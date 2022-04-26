//
//  Regex.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import Foundation

extension String {
    internal func matches(_ regex: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: self)
    }
    internal func matchesRegex(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}

internal enum Regex {
    internal static let url = "((http|https|ftp)://)?([(w|W)]{3}+\\.)?+(.)+\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
    internal static let emailStrict = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    internal static let emailLax = #".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"#
    
    // MARK: Phone
    // International Phone
    internal static let internationalPhoneFormat = #"(?:[0-9]){6,14}[0-9]$"#
    // North American Phone
    internal static let NANPPhoneFormat = #"^\(?([2-9][0-9]{2})\)?[-. ]?([2-9](?!11)[0-9]{2})[-. ]?([0-9]{4})$"#
    // European People's Party
    internal static let EPPPhoneFormat = #"^\+[0-9]{1,3}\.[0-9]{4,14}(?:x.+)?$"#
    
    // MARK: Credit Card
    // Visa
    internal static let visa = #"^4[0-9]{13,}?$"#
    // Master Card
    internal static let masterCard = #"^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"#
    // American Express
    internal static let amex = #"^3[47]\d{13,14}$"#
    // Discover
    internal static let discover = #"/^(?:6011\d{12})|(?:65\d{14})$/"#
}
