//
//  DatabaseObject.swift
//  CurrencyConverter
//
//  Created by Alexander Sobolev on 26.03.2024.
//

import Foundation

public protocol DatabaseObject: Codable {
    static var dataBaseKey: String { get }
}
