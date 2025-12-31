//
//  CalendarView.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var loanViewModel: LoanViewModel
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Month Selector
                MonthSelectorView(currentMonth: $currentMonth)
                
                // Calendar Grid
                CalendarGridView(
                    currentMonth: currentMonth,
                    loanItems: loanViewModel.activeItems,
                    selectedDate: $selectedDate
                )
                
                Divider()
                
                // Items for Selected Date
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Items due on \(selectedDate, style: .date)")
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        let itemsForDate = itemsDueOn(selectedDate)
                        
                        if itemsForDate.isEmpty {
                            Text("No items due on this date")
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                                .padding()
                        } else {
                        ForEach(itemsForDate) { item in
                            NavigationLink(destination: LoanDetailView(item: item, loanViewModel: loanViewModel, contactViewModel: ContactViewModel())) {
                                LoanItemRowView(item: item)
                            }
                        }
                        }
                    }
                }
            }
            .background(AppColors.background)
            .navigationTitle("Calendar")
        }
    }
    
    private func itemsDueOn(_ date: Date) -> [LoanItem] {
        let calendar = Calendar.current
        return loanViewModel.activeItems.filter { item in
            calendar.isDate(item.endDate, inSameDayAs: date)
        }
    }
}

struct MonthSelectorView: View {
    @Binding var currentMonth: Date
    
    var body: some View {
        HStack {
            Button(action: {
                currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.accent1)
            }
            
            Spacer()
            
            Text(currentMonth, format: .dateTime.month(.wide).year())
                .font(.headline)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: {
                currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.accent1)
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct CalendarGridView: View {
    let currentMonth: Date
    let loanItems: [LoanItem]
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            .background(Color.white)
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(calendarDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        hasItems: hasItemsOnDate(date),
                        itemStatus: getItemStatusForDate(date)
                    )
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding()
            .background(Color.white)
        }
    }
    
    private var calendarDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstDay = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstDay)
        let daysToSubtract = (firstDayWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstDay) else {
            return []
        }
        
        var days: [Date] = []
        var currentDate = startDate
        
        for _ in 0..<42 {
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return days
    }
    
    private func hasItemsOnDate(_ date: Date) -> Bool {
        loanItems.contains { item in
            calendar.isDate(item.endDate, inSameDayAs: date)
        }
    }
    
    private func getItemStatusForDate(_ date: Date) -> LoanStatus? {
        let itemsOnDate = loanItems.filter { calendar.isDate($0.endDate, inSameDayAs: date) }
        if let item = itemsOnDate.first {
            return item.status
        }
        return nil
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasItems: Bool
    let itemStatus: LoanStatus?
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(dayNumber)")
                .font(.subheadline)
                .foregroundColor(isCurrentMonth ? AppColors.textPrimary : AppColors.textSecondary.opacity(0.5))
            
            if hasItems, let status = itemStatus {
                Circle()
                    .fill(status.color)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(width: 40, height: 40)
        .background(isSelected ? AppColors.accent1.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}

#Preview {
    CalendarView(loanViewModel: LoanViewModel())
}

