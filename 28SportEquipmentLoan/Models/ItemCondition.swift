//
//  ItemCondition.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

enum ItemCondition: String, CaseIterable, Codable {
    case new = "New"
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    case damaged = "Damaged"
}

