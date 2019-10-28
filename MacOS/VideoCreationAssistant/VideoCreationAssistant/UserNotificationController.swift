//
//  UserNotificationController.swift
//  TutorialAssistant
//
//  Created by Michael Lustig on 9/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Cocoa

class UserNotificationController: NSObject, NSUserNotificationCenterDelegate {
    
    static let shared = UserNotificationController()
    
    // MARK: NSUserNotificationCenterDelegate
    
    
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        // Open URL if present in the informativeText field of a notification
        if let text = notification.informativeText, let url = URL(string: text) {
            
            NSWorkspace.shared.open(url)
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        // Always present notifications
        return true
    }
    
    // MARK: General
    
    func displayNotification(withTitle title: String, informativeText: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = informativeText
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
}
