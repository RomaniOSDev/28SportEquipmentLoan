//
//  LoanType.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

enum LoanType: String, CaseIterable, Codable {
    case rental = "Rental"
    case borrow = "Borrowed"
    case lend = "Lent Out"
    case demo = "Demo Equipment"
    case warranty = "Warranty"
}

