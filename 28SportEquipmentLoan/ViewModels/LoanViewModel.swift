//
//  LoanViewModel.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation
import SwiftUI
import Combine

class LoanViewModel: ObservableObject {
    @Published var loanItems: [LoanItem] = []
    @Published var filteredItems: [LoanItem] = []
    @Published var searchText: String = ""
    @Published var selectedStatus: LoanStatus?
    @Published var selectedType: EquipmentType?
    @Published var sortOption: SortOption = .dueDate
    
    enum SortOption: String, CaseIterable {
        case dueDate = "Due Date"
        case status = "Status"
        case name = "Name"
        case type = "Type"
    }
    
    private let userDefaultsKey = "loanItems"
    
    init() {
        loadItems()
        applyFilters()
    }
    
    func addItem(_ item: LoanItem) {
        loanItems.append(item)
        saveItems()
        applyFilters()
    }
    
    func updateItem(_ item: LoanItem) {
        if let index = loanItems.firstIndex(where: { $0.id == item.id }) {
            loanItems[index] = item
            saveItems()
            applyFilters()
        }
    }
    
    func deleteItem(_ item: LoanItem) {
        loanItems.removeAll { $0.id == item.id }
        saveItems()
        applyFilters()
    }
    
    func markAsReturned(_ item: LoanItem) {
        let updatedItem = item
        // Можно добавить логику для отметки как возвращенного
        updateItem(updatedItem)
    }
    
    func extendLoan(_ item: LoanItem, newEndDate: Date) {
        var updatedItem = item
        updatedItem.endDate = newEndDate
        updateItem(updatedItem)
    }
    
    func applyFilters() {
        filteredItems = loanItems
        
        // Search filter
        if !searchText.isEmpty {
            filteredItems = filteredItems.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.brand?.localizedCaseInsensitiveContains(searchText) ?? false ||
                item.owner.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Status filter
        if let status = selectedStatus {
            filteredItems = filteredItems.filter { $0.status == status }
        }
        
        // Type filter
        if let type = selectedType {
            filteredItems = filteredItems.filter { $0.type == type }
        }
        
        // Sort
        switch sortOption {
        case .dueDate:
            filteredItems.sort { $0.endDate < $1.endDate }
        case .status:
            filteredItems.sort { $0.status.rawValue < $1.status.rawValue }
        case .name:
            filteredItems.sort { $0.name < $1.name }
        case .type:
            filteredItems.sort { $0.type.rawValue < $1.type.rawValue }
        }
    }
    
    var activeItems: [LoanItem] {
        loanItems.filter { $0.status != .returned }
    }
    
    var dueSoonItems: [LoanItem] {
        loanItems.filter { $0.status == .dueSoon || $0.status == .dueToday }
    }
    
    var overdueItems: [LoanItem] {
        loanItems.filter { $0.status == .overdue }
    }
    
    var summaryText: String {
        let active = activeItems.count
        let dueSoon = dueSoonItems.count
        if dueSoon > 0 {
            return "\(active) items on loan, \(dueSoon) due soon"
        }
        return "\(active) items on loan"
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(loanItems) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([LoanItem].self, from: data) {
            loanItems = decoded
        }
    }
}

