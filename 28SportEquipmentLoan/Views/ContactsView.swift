//
//  ContactsView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var contactViewModel: ContactViewModel
    @State private var showingAddContact = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBarView(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        contactViewModel.searchText = newValue
                        contactViewModel.applyFilters()
                    }
                
                // Contacts List
                if contactViewModel.filteredContacts.isEmpty {
                    EmptyStateView(
                        icon: "person.circle",
                        title: "No Contacts",
                        message: "Tap + to add your first contact"
                    )
                } else {
                    List {
                        ForEach(contactViewModel.filteredContacts) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact, contactViewModel: contactViewModel)) {
                                ContactRowView(contact: contact)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(AppColors.background)
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddContact = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent1)
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddEditContactView(contactViewModel: contactViewModel)
            }
        }
    }
}

struct ContactRowView: View {
    let contact: Contact
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(AppColors.accent1.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(contact.name.prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundColor(AppColors.accent1)
                )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                if let company = contact.company {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                } else if let phone = contact.phone {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ContactDetailView: View {
    let contact: Contact
    @ObservedObject var contactViewModel: ContactViewModel
    @State private var showingEdit = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Avatar
                Circle()
                    .fill(AppColors.accent1.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(String(contact.name.prefix(1)).uppercased())
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(AppColors.accent1)
                    )
                    .padding(.top)
                
                // Name
                Text(contact.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                
                // Contact Info Card
                VStack(alignment: .leading, spacing: 16) {
                    if let company = contact.company {
                        ContactInfoRow(icon: "building.2", text: company)
                    }
                    
                    if let phone = contact.phone {
                        Button(action: {
                            if let url = URL(string: "tel://\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            ContactInfoRow(icon: "phone.fill", text: phone)
                        }
                    }
                    
                    if let email = contact.email {
                        Button(action: {
                            if let url = URL(string: "mailto:\(email)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            ContactInfoRow(icon: "envelope.fill", text: email)
                        }
                    }
                    
                    if let address = contact.address {
                        ContactInfoRow(icon: "mappin.circle.fill", text: address)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Notes
                if !contact.notes.isEmpty {
                    NotesCard(notes: contact.notes)
                }
            }
            .padding()
        }
        .background(AppColors.background)
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEdit = true
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddEditContactView(contactViewModel: contactViewModel, contact: contact)
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppColors.accent1)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
            Spacer()
        }
    }
}

struct AddEditContactView: View {
    @ObservedObject var contactViewModel: ContactViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var company: String = ""
    @State private var address: String = ""
    @State private var notes: String = ""
    
    var contact: Contact?
    var onSave: ((Contact) -> Void)?
    
    init(contactViewModel: ContactViewModel, contact: Contact? = nil, onSave: ((Contact) -> Void)? = nil) {
        self.contactViewModel = contactViewModel
        self.contact = contact
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Company (optional)", text: $company)
                }
                
                Section("Contact Information") {
                    TextField("Phone (optional)", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email (optional)", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Address (optional)", text: $address)
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(contact == nil ? "Add Contact" : "Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let contact = contact {
                    loadContact(contact)
                }
            }
        }
    }
    
    private func loadContact(_ contact: Contact) {
        name = contact.name
        phone = contact.phone ?? ""
        email = contact.email ?? ""
        company = contact.company ?? ""
        address = contact.address ?? ""
        notes = contact.notes
    }
    
    private func saveContact() {
        let newContact = Contact(
            id: contact?.id ?? UUID(),
            name: name,
            phone: phone.isEmpty ? nil : phone,
            email: email.isEmpty ? nil : email,
            company: company.isEmpty ? nil : company,
            address: address.isEmpty ? nil : address,
            notes: notes
        )
        
        if contact == nil {
            contactViewModel.addContact(newContact)
        } else {
            contactViewModel.updateContact(newContact)
        }
        
        onSave?(newContact)
        dismiss()
    }
}

#Preview {
    ContactsView(contactViewModel: ContactViewModel())
}

