//
//  LoanStatus.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

enum LoanStatus: String {
    case active = "Active"
    case dueSoon = "Due Soon"
    case dueToday = "Due Today"
    case overdue = "Overdue"
    case returned = "Returned"
    
    var color: Color {
        switch self {
        case .active: return Color(hex: "10B981")
        case .dueSoon: return Color(hex: "F59E0B")
        case .dueToday: return Color(hex: "EF4444")
        case .overdue: return Color(hex: "DC2626")
        case .returned: return Color(hex: "64748B")
        }
    }
}

