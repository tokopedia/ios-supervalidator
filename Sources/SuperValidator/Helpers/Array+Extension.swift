//
//  Array+Extension.swift
//
//
//  Created by Wendy Liga on 14/11/19.
//

import Foundation

extension Array {
    /**
     Access Array item safely, get rid of out of range fatal error

     - Parameter index: Array index you want to access

     ## How to Use:
     ```
     let array = [1,2,3,4,5,6,7,8,9]

     print(array[safe: 3]) -> result 4
     print(array[safe: 100]) -> result nil
     ```

     as setter
     ```
     let array = [1,2,3,4,5]
     array[safe: 0] = 0 -> [0,2,3,4,5]
     array[safe: 100] = 0 -> nothing
     ```

     ## Testing:
     I do several test on this function, you can check it here https://gist.github.com/wendyliga/7e9d97eea01dcabf3d65664a294f40a0

     don't hestitate to visit and put some suggestion or idea.
     */
    @inlinable
    public subscript(safe index: Index) -> Element? {
        get {
            guard startIndex <= index, index < endIndex else { return nil }

            return self[index]
        }
        set {
            guard
                let newValue = newValue,
                startIndex <= index, index < endIndex
            else {
                return
            }

            self[index] = newValue
        }
    }

    public func chunked(into size: Int) -> [[Element]] {
        guard size != 0 else { return [] }
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
