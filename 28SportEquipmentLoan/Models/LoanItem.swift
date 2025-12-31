//
//  LoanItem.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

struct LoanItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: EquipmentType
    var brand: String?
    var model: String?
    var serialNumber: String?
    var loanType: LoanType
    var owner: Contact
    var startDate: Date
    var endDate: Date
    var dailyRate: Double?
    var deposit: Double?
    var condition: ItemCondition
    var photos: [Data]?
    var notes: String
    
    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return components.day ?? 0
    }
    
    var status: LoanStatus {
        if daysRemaining < 0 {
            return .overdue
        } else if daysRemaining == 0 {
            return .dueToday
        } else if daysRemaining <= 3 {
            return .dueSoon
        } else {
            return .active
        }
    }
    
    var totalCost: Double? {
        guard let rate = dailyRate else { return nil }
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
        return Double(days) * rate
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        type: EquipmentType,
        brand: String? = nil,
        model: String? = nil,
        serialNumber: String? = nil,
        loanType: LoanType,
        owner: Contact,
        startDate: Date,
        endDate: Date,
        dailyRate: Double? = nil,
        deposit: Double? = nil,
        condition: ItemCondition,
        photos: [Data]? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.brand = brand
        self.model = model
        self.serialNumber = serialNumber
        self.loanType = loanType
        self.owner = owner
        self.startDate = startDate
        self.endDate = endDate
        self.dailyRate = dailyRate
        self.deposit = deposit
        self.condition = condition
        self.photos = photos
        self.notes = notes
    }
}

