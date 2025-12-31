//
//  MainDashboardView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var loanViewModel: LoanViewModel
    @ObservedObject var contactViewModel: ContactViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Card
                    SummaryCardView(viewModel: loanViewModel)
                    
                    // Quick Stats
                    QuickStatsView(viewModel: loanViewModel)
                    
                    // Active Loans List
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Active Loans")
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        if loanViewModel.activeItems.isEmpty {
                            EmptyStateView(
                                icon: "sportscourt",
                                title: "No Active Loans",
                                message: "Tap + to add your first item"
                            )
                        } else {
                            ForEach(loanViewModel.activeItems.prefix(5)) { item in
                                NavigationLink(destination: LoanDetailView(item: item, loanViewModel: loanViewModel, contactViewModel: contactViewModel)) {
                                    LoanItemRowView(item: item)
                                }
                            }
                        }
                    }
                    .padding(.top)
                    
                    // Upcoming Deadlines
                    if !loanViewModel.dueSoonItems.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Due This Week")
                                    .font(.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            ForEach(loanViewModel.dueSoonItems.prefix(3)) { item in
                                NavigationLink(destination: LoanDetailView(item: item, loanViewModel: loanViewModel, contactViewModel: contactViewModel)) {
                                    LoanItemRowView(item: item)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .background(AppColors.background)
            .navigationTitle("Sport Equipment Loan")
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

struct SummaryCardView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
            
            Text(viewModel.summaryText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
            
            HStack(spacing: 16) {
                StatBadgeView(
                    count: viewModel.activeItems.count,
                    label: "Active",
                    color: AppColors.active
                )
                
                if viewModel.dueSoonItems.count > 0 {
                    StatBadgeView(
                        count: viewModel.dueSoonItems.count,
                        label: "Due Soon",
                        color: AppColors.warning
                    )
                }
                
                if viewModel.overdueItems.count > 0 {
                    StatBadgeView(
                        count: viewModel.overdueItems.count,
                        label: "Overdue",
                        color: AppColors.overdue
                    )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct StatBadgeView: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct QuickStatsView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            QuickStatCard(
                icon: "clock.fill",
                value: "\(viewModel.activeItems.count)",
                label: "On Loan",
                color: AppColors.accent1
            )
            
            QuickStatCard(
                icon: "exclamationmark.triangle.fill",
                value: "\(viewModel.dueSoonItems.count)",
                label: "Due Soon",
                color: AppColors.warning
            )
            
            QuickStatCard(
                icon: "xmark.circle.fill",
                value: "\(viewModel.overdueItems.count)",
                label: "Overdue",
                color: AppColors.overdue
            )
        }
        .padding(.horizontal)
    }
}

struct QuickStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct LoanItemRowView: View {
    let item: LoanItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(item.status.color)
                .frame(width: 12, height: 12)
            
            // Icon
            Image(systemName: item.type.icon)
                .font(.title3)
                .foregroundColor(AppColors.accent1)
                .frame(width: 40, height: 40)
                .background(AppColors.accent1.opacity(0.1))
                .cornerRadius(8)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                HStack {
                    Text(item.owner.name)
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    if item.daysRemaining >= 0 {
                        Text("• \(item.daysRemaining) days left")
                            .font(.subheadline)
                            .foregroundColor(item.status.color)
                    } else {
                        Text("• Overdue")
                            .font(.subheadline)
                            .foregroundColor(AppColors.overdue)
                    }
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
        .padding(.horizontal)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(AppColors.textSecondary.opacity(0.5))
            
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

#Preview {
    MainDashboardView(loanViewModel: LoanViewModel(), contactViewModel: ContactViewModel())
}

