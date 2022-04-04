//
//  String+Extension.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import Foundation

extension String {
    internal var containsWhitespace: Bool {
        return (rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }

    internal func range(of aString: String) -> Int? {
        if let range: Range<String.Index> = self.range(of: aString) {
            let index = distance(from: startIndex, to: range.lowerBound)
            return index
        } else {
            return nil
        }
    }

    internal func removeSpaces() -> String {
        return removeCharacter(char: " ")
    }

    internal func removeDashes() -> String {
        return removeCharacter(char: "-")
    }

    internal func removeUnderscores() -> String {
        return removeCharacter(char: "_")
    }

    internal func removeCharacter(char: String) -> String {
        return replacingOccurrences(of: char, with: "")
    }
    
    internal func stringBefore(_ delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            return String(prefix(upTo: index))
        } else {
            return ""
        }
    }
    
}

// Phone Validator
extension String {
    internal func getCountryCodeNANP() -> String {
        var countryCode = self.stringBefore(")")
        countryCode.removeFirst()
        return countryCode
    }
    
    internal func getCountryCodeEPP() -> String {
        let countryCode = self.stringBefore(".")
        return countryCode
    }
}
