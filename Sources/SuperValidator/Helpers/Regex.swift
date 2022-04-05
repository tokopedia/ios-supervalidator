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
}

internal enum Regex {
    internal static let url = "((http|https|ftp)://)?([(w|W)]{3}+\\.)?+(.)+\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
    internal static let emailStrict = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    internal static let emailLax = #".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"#
}
