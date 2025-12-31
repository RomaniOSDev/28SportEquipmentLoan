//
//  ReminderViewModel.swift
//  28SportEquipmentLoan
//
//  Created by Роман Главацкий on 16.12.2025.
//

import Foundation
import UserNotifications
import Combine

class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    
    struct Reminder: Identifiable {
        let id: UUID
        let itemId: UUID
        let title: String
        let date: Date
        let type: ReminderType
        
        enum ReminderType {
            case returnDue
            case paymentDue
            case extensionReminder
        }
    }
    
    init() {
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("Notification permission granted")
            }
        }
    }
    
    func scheduleReminder(for item: LoanItem, daysBefore: Int = 1) {
        let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: item.endDate) ?? item.endDate
        
        let content = UNMutableNotificationContent()
        content.title = "Return Due Soon"
        content.body = "\(item.name) is due in \(daysBefore) day(s)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: item.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelReminder(for item: LoanItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
}

