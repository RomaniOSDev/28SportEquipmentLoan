//
//  ContactViewModel.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation
import SwiftUI
import Combine

class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var filteredContacts: [Contact] = []
    @Published var searchText: String = ""
    
    private let userDefaultsKey = "contacts"
    
    init() {
        loadContacts()
        applyFilters()
    }
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        saveContacts()
        applyFilters()
    }
    
    func updateContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
            saveContacts()
            applyFilters()
        }
    }
    
    func deleteContact(_ contact: Contact) {
        contacts.removeAll { $0.id == contact.id }
        saveContacts()
        applyFilters()
    }
    
    func getContact(by id: UUID) -> Contact? {
        contacts.first { $0.id == id }
    }
    
    func applyFilters() {
        if searchText.isEmpty {
            filteredContacts = contacts
        } else {
            filteredContacts = contacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.company?.localizedCaseInsensitiveContains(searchText) ?? false ||
                contact.phone?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        filteredContacts.sort { $0.name < $1.name }
    }
    
    private func saveContacts() {
        if let encoded = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadContacts() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Contact].self, from: data) {
            contacts = decoded
        }
    }
}

