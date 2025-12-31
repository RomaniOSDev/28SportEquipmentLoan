//
//  LoanItemsView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct LoanItemsView: View {
    @ObservedObject var loanViewModel: LoanViewModel
    @ObservedObject var contactViewModel: ContactViewModel
    @State private var showingAddItem = false
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBarView(text: $loanViewModel.searchText)
                    .onChange(of: loanViewModel.searchText) { _ in
                        loanViewModel.applyFilters()
                    }
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All",
                            isSelected: loanViewModel.selectedStatus == nil && loanViewModel.selectedType == nil,
                            action: {
                                loanViewModel.selectedStatus = nil
                                loanViewModel.selectedType = nil
                                loanViewModel.applyFilters()
                            }
                        )
                        
                        ForEach([LoanStatus.active, .dueSoon, .dueToday, .overdue], id: \.self) { status in
                            FilterChip(
                                title: status.rawValue,
                                isSelected: loanViewModel.selectedStatus == status,
                                color: status.color,
                                action: {
                                    loanViewModel.selectedStatus = loanViewModel.selectedStatus == status ? nil : status
                                    loanViewModel.applyFilters()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Sort Picker
                Picker("Sort", selection: $loanViewModel.sortOption) {
                    ForEach(LoanViewModel.SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: loanViewModel.sortOption) { _ in
                    loanViewModel.applyFilters()
                }
                
                // Items List
                if loanViewModel.filteredItems.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Items Found",
                        message: "Try adjusting your filters or search"
                    )
                } else {
                    List {
                        ForEach(loanViewModel.filteredItems) { item in
                            NavigationLink(destination: LoanDetailView(item: item, loanViewModel: loanViewModel, contactViewModel: contactViewModel)) {
                                LoanItemRowView(item: item)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(AppColors.background)
            .navigationTitle("Equipment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddItem = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.accent1)
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddEditLoanView(loanViewModel: loanViewModel, contactViewModel: contactViewModel)
            }
        }
    }
}

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            
            TextField("Search by name, brand, contact...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = AppColors.accent1
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : Color.white)
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.clear : AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    LoanItemsView(loanViewModel: LoanViewModel(), contactViewModel: ContactViewModel())
}

