//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Berkay YAY on 23.02.2023.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
