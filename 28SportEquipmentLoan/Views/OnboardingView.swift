//
//  OnboardingView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "sportscourt.fill",
                        title: "Track Your Equipment",
                        description: "Keep track of all your rented, borrowed, or loaned sports equipment in one place. Never lose track of what you have and when it's due.",
                        color: AppColors.accent1
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "calendar.badge.clock",
                        title: "Never Miss a Deadline",
                        description: "Get reminders and countdown timers for return dates. Stay on top of your equipment loans and avoid late fees.",
                        color: AppColors.warning
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "person.2.fill",
                        title: "Manage Contacts",
                        description: "Keep all your rental contacts organized. Quick access to call or email rental companies and lenders.",
                        color: AppColors.active
                    )
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // Bottom Buttons
                VStack(spacing: 16) {
                    // Action Buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Previous")
                                    .font(.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < 2 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                viewModel.completeOnboarding()
                            }
                        }) {
                            Text(currentPage < 2 ? "Next" : "Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.accent1)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: icon)
                    .font(.system(size: 80))
                    .foregroundColor(color)
            }
            
            // Text Content
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}

