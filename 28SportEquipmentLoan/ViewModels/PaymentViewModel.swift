//
//  PaymentViewModel.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation
import SwiftUI
import Combine

class PaymentViewModel: ObservableObject {
    @Published var payments: [PaymentRecord] = []
    
    private let userDefaultsKey = "payments"
    
    init() {
        loadPayments()
    }
    
    func addPayment(_ payment: PaymentRecord) {
        payments.append(payment)
        savePayments()
    }
    
    func deletePayment(_ payment: PaymentRecord) {
        payments.removeAll { $0.id == payment.id }
        savePayments()
    }
    
    func payments(for itemId: UUID) -> [PaymentRecord] {
        payments.filter { $0.itemId == itemId }
    }
    
    var totalSpent: Double {
        payments.reduce(0) { $0 + $1.amount }
    }
    
    var monthlySpending: [String: Double] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        
        var monthly: [String: Double] = [:]
        for payment in payments {
            let month = formatter.string(from: payment.date)
            monthly[month, default: 0] += payment.amount
        }
        
        return monthly
    }
    
    var upcomingPayments: [PaymentRecord] {
        let futureDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        return payments.filter { $0.date > Date() && $0.date <= futureDate }
    }
    
    private func savePayments() {
        if let encoded = try? JSONEncoder().encode(payments) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadPayments() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([PaymentRecord].self, from: data) {
            payments = decoded
        }
    }
}

