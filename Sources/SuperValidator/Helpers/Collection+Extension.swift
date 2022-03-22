//
//  Collection+Extension.swift
//  
//
//  Created by alvin.pratama on 22/03/22.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    internal var isNotEmpty: Bool {
        !isEmpty
    }
}
