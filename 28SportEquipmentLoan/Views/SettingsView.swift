//
//  SettingsView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacy = false
    @State private var showingTerms = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    SettingsRowView(
                        icon: "star.fill",
                        iconColor: AppColors.warning,
                        title: "Rate Us",
                        action: {
                            rateApp()
                        }
                    )
                    
                    SettingsRowView(
                        icon: "lock.shield.fill",
                        iconColor: AppColors.accent1,
                        title: "Privacy Policy",
                        action: {
                            if let url = URL(string: "https://www.termsfeed.com/live/76933ba1-9417-4cc4-bffa-50279ecb8cf2") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    SettingsRowView(
                        icon: "doc.text.fill",
                        iconColor: AppColors.textPrimary,
                        title: "Terms of Service",
                        action: {
                            if let url = URL(string: "https://www.termsfeed.com/live/2efbc29f-8461-430b-bc19-2d989b083dff") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Text("Sport Equipment Loan")
                                .font(.headline)
                                .foregroundColor(AppColors.textPrimary)
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPrivacy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingTerms) {
                TermsOfServiceView()
            }
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, 8)
                    
                    Text("Last Updated: December 2025")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("""
                    At Sport Equipment Loan, we take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your information when you use our application.
                    
                    Information We Collect
                    We collect information that you provide directly to us, including:
                    - Equipment loan details (names, dates, contacts)
                    - Contact information (names, phone numbers, emails)
                    - Payment records
                    - Notes and photos related to your equipment
                    
                    How We Use Your Information
                    We use the information we collect to:
                    - Provide and improve our services
                    - Send you reminders and notifications
                    - Manage your equipment loans
                    - Process payments and transactions
                    
                    Data Storage
                    All your data is stored locally on your device. We do not transmit, share, or store your data on external servers without your explicit consent.
                    
                    Your Rights
                    You have the right to:
                    - Access your personal data
                    - Delete your data at any time
                    - Export your data
                    - Opt out of notifications
                    
                    Contact Us
                    If you have any questions about this Privacy Policy, please contact us through the app settings.
                    """)
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                    .lineSpacing(4)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Privacy Policy")
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

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Terms of Service")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(.bottom, 8)
                    
                    Text("Last Updated: December 2025")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("""
                    Welcome to Sport Equipment Loan. By using our application, you agree to the following terms and conditions.
                    
                    Acceptance of Terms
                    By downloading, installing, or using Sport Equipment Loan, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.
                    
                    Use of the Application
                    You agree to use the application only for lawful purposes and in accordance with these Terms. You are responsible for:
                    - Maintaining the accuracy of your information
                    - Keeping your device secure
                    - Complying with all applicable laws and regulations
                    
                    Equipment Management
                    This application is a tool to help you manage your equipment loans. We are not responsible for:
                    - Any disputes between you and equipment lenders
                    - Loss or damage to equipment
                    - Late fees or penalties
                    - Accuracy of loan terms or dates
                    
                    Limitation of Liability
                    Sport Equipment Loan is provided "as is" without warranties of any kind. We are not liable for any damages arising from your use of the application.
                    
                    Data Responsibility
                    You are responsible for backing up your data. We recommend regularly exporting your information to prevent data loss.
                    
                    Changes to Terms
                    We reserve the right to modify these terms at any time. Continued use of the application constitutes acceptance of modified terms.
                    
                    Contact
                    For questions about these Terms, please contact us through the app settings.
                    """)
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                    .lineSpacing(4)
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle("Terms of Service")
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
    SettingsView()
}

