//
//  LoanAction.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

enum LoanAction: String, CaseIterable, Codable {
    case borrowed = "Borrowed"
    case extended = "Extended"
    case returned = "Returned"
    case damaged = "Damaged"
    case repaired = "Repaired"
    case paid = "Paid"
    case contacted = "Contacted"
}

struct LoanHistory: Identifiable, Codable {
    let id: UUID
    var itemId: UUID
    var action: LoanAction
    var date: Date
    var notes: String?
    var photos: [Data]?
    
    init(id: UUID = UUID(), itemId: UUID, action: LoanAction, date: Date, notes: String? = nil, photos: [Data]? = nil) {
        self.id = id
        self.itemId = itemId
        self.action = action
        self.date = date
        self.notes = notes
        self.photos = photos
    }
}

