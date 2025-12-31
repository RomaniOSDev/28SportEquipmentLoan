//
//  PaymentMethod.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

enum PaymentMethod: String, CaseIterable, Codable {
    case cash = "Cash"
    case card = "Card"
    case bankTransfer = "Bank Transfer"
    case digital = "Digital"
    case other = "Other"
}

struct PaymentRecord: Identifiable, Codable {
    let id: UUID
    var itemId: UUID
    var amount: Double
    var date: Date
    var method: PaymentMethod
    var notes: String?
    
    init(id: UUID = UUID(), itemId: UUID, amount: Double, date: Date, method: PaymentMethod, notes: String? = nil) {
        self.id = id
        self.itemId = itemId
        self.amount = amount
        self.date = date
        self.method = method
        self.notes = notes
    }
}

