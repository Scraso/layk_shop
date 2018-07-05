//
//  Array + SafeIndex.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/3/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
