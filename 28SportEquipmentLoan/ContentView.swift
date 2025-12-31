//
//  ContentView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loanViewModel = LoanViewModel()
    @StateObject private var contactViewModel = ContactViewModel()
    @StateObject private var paymentViewModel = PaymentViewModel()
    @StateObject private var reminderViewModel = ReminderViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        Group {
            if onboardingViewModel.hasCompletedOnboarding {
                MainTabView(
                    loanViewModel: loanViewModel,
                    contactViewModel: contactViewModel,
                    paymentViewModel: paymentViewModel
                )
            } else {
                OnboardingView(viewModel: onboardingViewModel)
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var loanViewModel: LoanViewModel
    @ObservedObject var contactViewModel: ContactViewModel
    @ObservedObject var paymentViewModel: PaymentViewModel
    
    var body: some View {
        TabView {
            MainDashboardView(loanViewModel: loanViewModel, contactViewModel: contactViewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            LoanItemsView(loanViewModel: loanViewModel, contactViewModel: contactViewModel)
                .tabItem {
                    Label("Equipment", systemImage: "sportscourt.fill")
                }
            
            CalendarView(loanViewModel: loanViewModel)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            ContactsView(contactViewModel: contactViewModel)
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
            
            PaymentsView(paymentViewModel: paymentViewModel, loanViewModel: loanViewModel)
                .tabItem {
                    Label("Payments", systemImage: "creditcard.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(AppColors.accent1)
    }
}

#Preview {
    ContentView()
}
