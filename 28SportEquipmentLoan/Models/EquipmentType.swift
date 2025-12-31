//
//  EquipmentType.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation

enum EquipmentType: String, CaseIterable, Codable {
    case ski = "Ski"
    case snowboard = "Snowboard"
    case bicycle = "Bicycle"
    case climbing = "Climbing"
    case diving = "Diving"
    case golf = "Golf"
    case tennis = "Tennis"
    case fitness = "Fitness"
    case waterSports = "Water Sports"
    case winterSports = "Winter Sports"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .ski: return "figure.skiing"
        case .snowboard: return "snowboard"
        case .bicycle: return "bicycle"
        case .climbing: return "figure.climbing"
        case .diving: return "water.waves"
        case .golf: return "figure.golf"
        case .tennis: return "figure.tennis"
        case .fitness: return "dumbbell"
        case .waterSports: return "figure.waterpolo"
        case .winterSports: return "snowflake"
        case .other: return "sportscourt"
        }
    }
}

