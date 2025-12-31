//
//  Contact.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

struct Contact: Identifiable, Codable {
    let id: UUID
    var name: String
    var phone: String?
    var email: String?
    var company: String?
    var address: String?
    var notes: String
    
    init(id: UUID = UUID(), name: String, phone: String? = nil, email: String? = nil, company: String? = nil, address: String? = nil, notes: String = "") {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.company = company
        self.address = address
        self.notes = notes
    }
}

