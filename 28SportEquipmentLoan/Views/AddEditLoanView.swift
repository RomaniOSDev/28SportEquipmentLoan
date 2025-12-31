//
//  AddEditLoanView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct AddEditLoanView: View {
    @ObservedObject var loanViewModel: LoanViewModel
    @ObservedObject var contactViewModel: ContactViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var selectedType: EquipmentType = .other
    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var serialNumber: String = ""
    @State private var selectedLoanType: LoanType = .rental
    @State private var selectedContact: Contact?
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var dailyRate: String = ""
    @State private var deposit: String = ""
    @State private var selectedCondition: ItemCondition = .good
    @State private var notes: String = ""
    @State private var showingContactPicker = false
    @State private var showingNewContact = false
    
    var item: LoanItem?
    
    init(loanViewModel: LoanViewModel, contactViewModel: ContactViewModel, item: LoanItem? = nil) {
        self.loanViewModel = loanViewModel
        self.contactViewModel = contactViewModel
        self.item = item
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Basic Info Section
                Section("Basic Information") {
                    TextField("Item Name", text: $name)
                    
                    Picker("Equipment Type", selection: $selectedType) {
                        ForEach(EquipmentType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }.tag(type)
                        }
                    }
                    
                    TextField("Brand (optional)", text: $brand)
                    TextField("Model (optional)", text: $model)
                    TextField("Serial Number (optional)", text: $serialNumber)
                    
                    Picker("Loan Type", selection: $selectedLoanType) {
                        ForEach(LoanType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Condition", selection: $selectedCondition) {
                        ForEach(ItemCondition.allCases, id: \.self) { condition in
                            Text(condition.rawValue).tag(condition)
                        }
                    }
                }
                
                // Contact Section
                Section("Contact") {
                    if let contact = selectedContact {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                if let company = contact.company {
                                    Text(company)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            Spacer()
                            Button("Change") {
                                showingContactPicker = true
                            }
                        }
                    } else {
                        Button("Select Contact") {
                            showingContactPicker = true
                        }
                        Button("Create New Contact") {
                            showingNewContact = true
                        }
                    }
                }
                
                // Dates Section
                Section("Rental Period") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                // Financial Section
                Section("Financial") {
                    HStack {
                        Text("Daily Rate")
                        Spacer()
                        TextField("0.00", text: $dailyRate)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Deposit")
                        Spacer()
                        TextField("0.00", text: $deposit)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                // Notes Section
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle(item == nil ? "Add Item" : "Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView(
                    contactViewModel: contactViewModel,
                    selectedContact: $selectedContact
                )
            }
            .sheet(isPresented: $showingNewContact) {
                AddEditContactView(contactViewModel: contactViewModel) { newContact in
                    selectedContact = newContact
                }
            }
            .onAppear {
                if let item = item {
                    loadItem(item)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && selectedContact != nil
    }
    
    private func loadItem(_ item: LoanItem) {
        name = item.name
        selectedType = item.type
        brand = item.brand ?? ""
        model = item.model ?? ""
        serialNumber = item.serialNumber ?? ""
        selectedLoanType = item.loanType
        selectedContact = item.owner
        startDate = item.startDate
        endDate = item.endDate
        dailyRate = item.dailyRate.map { String($0) } ?? ""
        deposit = item.deposit.map { String($0) } ?? ""
        selectedCondition = item.condition
        notes = item.notes
    }
    
    private func saveItem() {
        guard let contact = selectedContact else { return }
        
        let newItem = LoanItem(
            id: item?.id ?? UUID(),
            name: name,
            type: selectedType,
            brand: brand.isEmpty ? nil : brand,
            model: model.isEmpty ? nil : model,
            serialNumber: serialNumber.isEmpty ? nil : serialNumber,
            loanType: selectedLoanType,
            owner: contact,
            startDate: startDate,
            endDate: endDate,
            dailyRate: Double(dailyRate),
            deposit: Double(deposit),
            condition: selectedCondition,
            photos: nil,
            notes: notes
        )
        
        if item == nil {
            loanViewModel.addItem(newItem)
        } else {
            loanViewModel.updateItem(newItem)
        }
        
        dismiss()
    }
}

struct ContactPickerView: View {
    @ObservedObject var contactViewModel: ContactViewModel
    @Binding var selectedContact: Contact?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(contactViewModel.contacts) { contact in
                    Button(action: {
                        selectedContact = contact
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                if let company = contact.company {
                                    Text(company)
                                        .font(.subheadline)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            Spacer()
                            if selectedContact?.id == contact.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.accent1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddEditLoanView(loanViewModel: LoanViewModel(), contactViewModel: ContactViewModel())
}

