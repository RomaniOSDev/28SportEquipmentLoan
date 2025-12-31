//
//  LoanDetailView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct LoanDetailView: View {
    let item: LoanItem
    @ObservedObject var loanViewModel: LoanViewModel
    @ObservedObject var contactViewModel: ContactViewModel
    @State private var showingEdit = false
    @State private var showingExtend = false
    @State private var showingReturn = false
    @State private var showingContact = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Timer Card
                CountdownTimerCard(item: item)
                
                // Item Info Card
                ItemInfoCard(item: item)
                
                // Contact Card
                ContactCard(contact: item.owner)
                    .onTapGesture {
                        showingContact = true
                    }
                
                // Financial Card
                if item.dailyRate != nil || item.deposit != nil {
                    FinancialCard(item: item)
                }
                
                // Action Buttons
                ActionButtonsView(
                    item: item,
                    loanViewModel: loanViewModel,
                    showingExtend: $showingExtend,
                    showingReturn: $showingReturn
                )
                
                // Notes
                if !item.notes.isEmpty {
                    NotesCard(notes: item.notes)
                }
            }
            .padding()
        }
        .background(AppColors.background)
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEdit = true
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddEditLoanView(loanViewModel: loanViewModel, contactViewModel: contactViewModel, item: item)
        }
        .sheet(isPresented: $showingExtend) {
            ExtendLoanView(item: item, loanViewModel: loanViewModel)
        }
        .sheet(isPresented: $showingReturn) {
            ReturnItemView(item: item, loanViewModel: loanViewModel)
        }
        .sheet(isPresented: $showingContact) {
            ContactDetailView(contact: item.owner, contactViewModel: contactViewModel)
        }
    }
}

struct CountdownTimerCard: View {
    let item: LoanItem
    
    var body: some View {
        VStack(spacing: 16) {
            Text(item.status.rawValue)
                .font(.headline)
                .foregroundColor(item.status.color)
            
            if item.daysRemaining >= 0 {
                VStack(spacing: 4) {
                    Text("\(item.daysRemaining)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    Text(item.daysRemaining == 1 ? "day remaining" : "days remaining")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
            } else {
                VStack(spacing: 4) {
                    Text("\(abs(item.daysRemaining))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(AppColors.overdue)
                    Text("days overdue")
                        .font(.subheadline)
                        .foregroundColor(AppColors.overdue)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(item.startDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("End Date")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    Text(item.endDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textPrimary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ItemInfoCard: View {
    let item: LoanItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Item Information")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            InfoRow(label: "Type", value: item.type.rawValue, icon: item.type.icon)
            InfoRow(label: "Loan Type", value: item.loanType.rawValue)
            
            if let brand = item.brand {
                InfoRow(label: "Brand", value: brand)
            }
            
            if let model = item.model {
                InfoRow(label: "Model", value: model)
            }
            
            if let serialNumber = item.serialNumber {
                InfoRow(label: "Serial Number", value: serialNumber)
            }
            
            InfoRow(label: "Condition", value: item.condition.rawValue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var icon: String?
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(AppColors.accent1)
                    .frame(width: 20)
            }
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

struct ContactCard: View {
    let contact: Contact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contact Information")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Text(contact.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.textPrimary)
            
            if let company = contact.company {
                Text(company)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            HStack {
                if let phone = contact.phone {
                    Button(action: {
                        if let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label(phone, systemImage: "phone.fill")
                            .font(.subheadline)
                            .foregroundColor(AppColors.accent1)
                    }
                }
                
                if let email = contact.email {
                    Button(action: {
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label(email, systemImage: "envelope.fill")
                            .font(.subheadline)
                            .foregroundColor(AppColors.accent1)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct FinancialCard: View {
    let item: LoanItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Financial Information")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            if let dailyRate = item.dailyRate {
                InfoRow(label: "Daily Rate", value: String(format: "$%.2f", dailyRate))
            }
            
            if let deposit = item.deposit {
                InfoRow(label: "Deposit", value: String(format: "$%.2f", deposit))
            }
            
            if let totalCost = item.totalCost {
                Divider()
                HStack {
                    Text("Total Cost")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Text(String(format: "$%.2f", totalCost))
                        .font(.headline)
                        .foregroundColor(AppColors.accent1)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ActionButtonsView: View {
    let item: LoanItem
    @ObservedObject var loanViewModel: LoanViewModel
    @Binding var showingExtend: Bool
    @Binding var showingReturn: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            if item.status != .returned {
                Button(action: { showingExtend = true }) {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Extend Loan")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.accent1)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: { showingReturn = true }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Returned")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.active)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct NotesCard: View {
    let notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Text(notes)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ExtendLoanView: View {
    let item: LoanItem
    @ObservedObject var loanViewModel: LoanViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newEndDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Current End Date") {
                    Text(item.endDate, style: .date)
                }
                
                Section("New End Date") {
                    DatePicker("Select Date", selection: $newEndDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Extend Loan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        loanViewModel.extendLoan(item, newEndDate: newEndDate)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ReturnItemView: View {
    let item: LoanItem
    @ObservedObject var loanViewModel: LoanViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Mark \(item.name) as returned?")
                    .font(.headline)
                    .padding()
                
                Button("Confirm Return") {
                    loanViewModel.markAsReturned(item)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColors.active)
            }
            .navigationTitle("Return Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        LoanDetailView(
            item: LoanItem(
                name: "Mountain Bike",
                type: .bicycle,
                brand: "Trek",
                loanType: .rental,
                owner: Contact(name: "John Doe", phone: "+1234567890"),
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                dailyRate: 25.0,
                condition: .good
            ),
            loanViewModel: LoanViewModel(),
            contactViewModel: ContactViewModel()
        )
    }
}

