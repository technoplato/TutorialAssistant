//
//  Preferences.swift
//  TutorialAssistant
//
//  Created by Michael Lustig on 9/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

enum Preference: String {
    
    enum Category: String {
        case general, screenshots
        
        static var allValues: [Category] = [.general, .screenshots]
        
        var name: String {
            return rawValue.capitalized
        }
    }
    
    case deleteScreenshotsAfterUpload = "DeleteScreenshotAfterUpload"
    case disableScreenshotDetection = "DisableScreenshotDetection"
    case requiresUploadConfirmation = "RequiresUploadConfirmation"
    case resizeScreenshots = "ResizeScreenshots"
    case clearClipboard = "ClearClipboard"
    case copyLinkToClipboard = "CopyLink"
    
    // TODO: Better alternative to this?
    static let allValues: [Preference] = [
        .deleteScreenshotsAfterUpload,
        .disableScreenshotDetection,
        .requiresUploadConfirmation,
        .resizeScreenshots,
        .clearClipboard,
        .copyLinkToClipboard
    ]
    
    /// The human readable description of the preference.
    var description: String {
        switch self {
        case .deleteScreenshotsAfterUpload:
            return "Delete After Upload"
        case .disableScreenshotDetection:
            return "Disable Detection"
        case .requiresUploadConfirmation:
            return "Request Confirmation Before Upload"
        case .resizeScreenshots:
            return "Downscale from Retina"
        case .clearClipboard:
            return "Clear Clipboard"
        case .copyLinkToClipboard:
            return "Copy Link to Clipboard"
        }
    }
    
    var category: Category {
        switch self {
        case .clearClipboard, .copyLinkToClipboard:
            return .general
        default:
            return .screenshots
        }
    }
    
    /// The corresponding value from `UserDefaults`.
    var value: Bool {
        return UserDefaults.standard.bool(forKey: rawValue)
    }
    
    /// The initial value for the preference.
    var defaultValue: Bool {
        switch self {
        case .copyLinkToClipboard:
            return true
        default:
            return false
        }
    }
    
}

