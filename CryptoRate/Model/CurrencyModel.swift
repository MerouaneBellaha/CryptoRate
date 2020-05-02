//
//  CurrencyModel.swift
//  CryptoRate
//
//  Created by Merouane Bellaha on 02/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct CurrencyModel {
    let rate: Double
    var formatedRate : String {
        return String(format: "%.8f", rate)
    }
}
