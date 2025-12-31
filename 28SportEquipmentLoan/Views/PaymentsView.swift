//
//  PaymentsView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct PaymentsView: View {
    @ObservedObject var paymentViewModel: PaymentViewModel
    @ObservedObject var loanViewModel: LoanViewModel
    @State private var showingAddPayment = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Total Spent Card
                    TotalSpentCard(total: paymentViewModel.totalSpent)
                    
                    // Monthly Spending
                    if !paymentViewModel.monthlySpending.isEmpty {
                        MonthlySpendingCard(monthlySpending: paymentViewModel.monthlySpending)
                    }
                    
                    // Upcoming Payments
                    if !paymentViewModel.upcomingPayments.isEmpty {
                        UpcomingPaymentsSection(payments: paymentViewModel.upcomingPayments, loanViewModel: loanViewModel)
                    }
                    
                    // Payment History
                    PaymentHistorySection(
                        payments: paymentViewModel.payments,
                        loanViewModel: loanViewModel
                    )
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Payments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPayment = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent1)
                    }
                }
            }
            .sheet(isPresented: $showingAddPayment) {
                AddPaymentView(paymentViewModel: paymentViewModel, loanViewModel: loanViewModel)
            }
        }
    }
}

struct TotalSpentCard: View {
    let total: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Total Spent")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            
            Text(String(format: "$%.2f", total))
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct MonthlySpendingCard: View {
    let monthlySpending: [String: Double]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Spending")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            ForEach(Array(monthlySpending.keys.sorted().reversed().prefix(6)), id: \.self) { month in
                HStack {
                    Text(formatMonth(month))
                        .font(.subheadline)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Text(String(format: "$%.2f", monthlySpending[month] ?? 0))
                        .font(.subheadline)
                        .fontWeight(.semibold)
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
    
    private func formatMonth(_ monthString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        if let date = formatter.date(from: monthString) {
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
        return monthString
    }
}

struct UpcomingPaymentsSection: View {
    let payments: [PaymentRecord]
    @ObservedObject var loanViewModel: LoanViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Payments")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            ForEach(payments.prefix(5)) { payment in
                PaymentRowView(payment: payment, loanViewModel: loanViewModel)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct PaymentHistorySection: View {
    let payments: [PaymentRecord]
    @ObservedObject var loanViewModel: LoanViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment History")
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            if payments.isEmpty {
                EmptyStateView(
                    icon: "creditcard",
                    title: "No Payments",
                    message: "Add your first payment record"
                )
            } else {
                ForEach(payments.sorted(by: { $0.date > $1.date })) { payment in
                    PaymentRowView(payment: payment, loanViewModel: loanViewModel)
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

struct PaymentRowView: View {
    let payment: PaymentRecord
    @ObservedObject var loanViewModel: LoanViewModel
    
    var itemName: String {
        loanViewModel.loanItems.first(where: { $0.id == payment.itemId })?.name ?? "Unknown Item"
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(itemName)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                HStack {
                    Text(payment.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("•")
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(payment.method.rawValue)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", payment.amount))
                .font(.headline)
                .foregroundColor(AppColors.accent1)
        }
        .padding(.vertical, 4)
    }
}

struct AddPaymentView: View {
    @ObservedObject var paymentViewModel: PaymentViewModel
    @ObservedObject var loanViewModel: LoanViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedItemId: UUID?
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var selectedMethod: PaymentMethod = .cash
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item") {
                    Picker("Item", selection: $selectedItemId) {
                        Text("Select Item").tag(nil as UUID?)
                        ForEach(loanViewModel.loanItems) { item in
                            Text(item.name).tag(item.id as UUID?)
                        }
                    }
                }
                
                Section("Payment Details") {
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    Picker("Method", selection: $selectedMethod) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                }
                
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePayment()
                    }
                    .disabled(selectedItemId == nil || amount.isEmpty)
                }
            }
        }
    }
    
    private func savePayment() {
        guard let itemId = selectedItemId,
              let amountValue = Double(amount) else { return }
        
        let payment = PaymentRecord(
            itemId: itemId,
            amount: amountValue,
            date: date,
            method: selectedMethod,
            notes: notes.isEmpty ? nil : notes
        )
        
        paymentViewModel.addPayment(payment)
        dismiss()
    }
}

#Preview {
    PaymentsView(paymentViewModel: PaymentViewModel(), loanViewModel: LoanViewModel())
}

