//
//  Symbol.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import Foundation

struct Symbol {
    let name: String
    let quote: Quote
}

struct Quote {
    let bid: String
    let ask: String
    let last: String
    let high: String
    let low: String
    let dateTime: String
    let change: String
    let changePercent: String
}
