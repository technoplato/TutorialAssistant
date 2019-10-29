//
//  ImgurClient.swift
//  TutorialAssistant
//
//  Created by Michael Lustig on 9/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation
import ImgurSession

class ImgurClient: NSObject, IMGSessionDelegate {
  
  static let shared = ImgurClient()
  
  var externalWebViewCompletionHandler: (() -> Void)?
  var callback: ((String) -> Void)?
  
  // MARK: Defaults keys
  
  let refreshTokenKey = "RefreshToken"
  let imgurAlbumKey = "ImgurAlbum"
  
  // MARK: Imgur tokens
  
  let clientID = "0865c5c16367c1c"
  let clientSecret = "e0d839d6368e9d10f62606e88b98c09e452d7240"
  
  // MARK: General
  
  var uploadAlbumID: String? {
    get {
      return UserDefaults.standard.string(forKey: imgurAlbumKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: imgurAlbumKey)
    }
  }
  
  /// Prepare ImgurClient for use.
  func setup() {
//    let foo = "81defd86001a83eea925a397c13bd3fbfa8354f9"
//    configure(asAnonymous: false)
//
//
//
//    IMGSession.sharedInstance()
//      .authenticate(withRefreshToken: foo)
    
    if let refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey) {
      configure(asAnonymous: false)

      IMGSession.sharedInstance()
        .authenticate(withRefreshToken: refreshToken)
    } else {
      configure(asAnonymous: true)
    }
  }
  
  func handle(error: Error?, title: String) {
    UserNotificationController.shared.displayNotification(
      withTitle: title,
      informativeText: description(of: error))
    
  }
  
  func description(of error: Error?) -> String {
    
    if let error = error as NSError? {
      
      let localizedDescription = error.userInfo[NSLocalizedDescriptionKey]
      
      if localizedDescription is String {
        
        return error.localizedDescription
        
      } else if let data = localizedDescription as? [String: Any],
        let message = data["message"] as? String {
        
        return message
        
      }
      
    }
    
    return "An unknown error occurred."
  }
  
  /// Configures the `IMGSession.sharedInstance()`
  /// - parameter anonymous: If the session should be configured for anonymous
  /// API access, or alternatively authenticated.
  func configure(asAnonymous anonymous: Bool) {
    if anonymous {
      IMGSession.anonymousSession(
        withClientID: clientID,
        with: self)
    } else {
      IMGSession.authenticatedSession(
        withClientID: clientID,
        secret: clientSecret,
        authType: .codeAuth,
        with: self)
      
      // Disable notification update requests
      IMGSession.sharedInstance().notificationRefreshPeriod = 0
    }
  }
  
  func authenticate() {
    configure(asAnonymous: false)
    IMGSession.sharedInstance().authenticate()
  }
  
  func deauthenticate() {
    // Clear stored refresh token
    UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    UserDefaults.standard.removeObject(forKey: imgurAlbumKey)
    
    configure(asAnonymous: true)
  }
  
  /// Requests manual upload confirmation from the user if required,
  /// otherwise returns `true`
  /// - parameter upload: The upload for which confirmation is required
  func hasUploadConfirmation(forImageNamed imageName: String, imageData: Data) -> Bool {
    // Manual upload confirmation may not be required
    if !Preference.requiresUploadConfirmation.value {
      return true
    }
    
    let alert = NSAlert()
    alert.messageText = "Do you want to upload this screenshot?"
    alert.informativeText = "\"\(imageName)\" will be uploaded to imgur.com, where it will be publicly accessible."
    alert.addButton(withTitle: "Upload")
    alert.addButton(withTitle: "Cancel")
    alert.icon = NSImage(data: imageData)
    
    NSApp.activate(ignoringOtherApps: true)
    return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
  }
  
  
  // MARK: Imgur Upload
  
  /// Uploads the image at the specified URL.
  /// - parameter imageURL: The URL to the image to be uploaded
  /// - parameter isScreenshot: Whether the image is a screenshot or not,
  /// affects which preferences will be applied to the upload
  func uploadImage(withURL imageURL: URL, isScreenshot: Bool) {
    
    var imageData: Data
    
    do {
      imageData = try Data(contentsOf: imageURL)
    } catch let error {
      uploadFailureHandler(dataTask: nil, error: error)
      return
    }
    
    let imageName = imageURL.lastPathComponent
    
    // Screenshot specific preferences
    if isScreenshot {
      
      if Preference.disableScreenshotDetection.value
        || !hasUploadConfirmation(forImageNamed: imageName, imageData: imageData) {
        return // Skip, do not upload
      }
      
    }
    
    uploadImage(withData: imageData,
                imageTitle: NSString(string: imageName).deletingPathExtension)
  }
  
  /// Uploads the specified image data
  /// - parameter imageData: The image data of which to upload
  /// - parameter imageTitle: The title of the image (defaults to "Untitled")
  func uploadImage(withData imageData: Data, imageTitle: String = "Untitled") {
    
    // Clear clipboard if required
    if Preference.clearClipboard.value {
      NSPasteboard.general.clearContents()
    }
    
    IMGImageRequest.uploadImage(with: imageData,
                                title: imageTitle,
                                description: nil,
                                linkToAlbumWithID: uploadAlbumID,
                                progress: nil,
                                success: uploadSuccessHandler,
                                failure: uploadFailureHandler)
    
  }
  
  func uploadSuccessHandler(_ image: IMGImage?) {
    guard let image = image,
      let urlString = image.url.absoluteString as String? else {
        return
    }
    
    if (callback != nil) {
      callback!(urlString)
    }
    //        ImgurImageStore.shared.addImage(image)
    
    NSPasteboard.general.clearContents()
    NSPasteboard.general
      .setString(urlString, forType: NSPasteboard.PasteboardType.string)
    
    
    UserNotificationController.shared.displayNotification(
      withTitle: "Imgur Upload Succeeded",
      informativeText: urlString)
  }
  
  func uploadFailureHandler(dataTask: URLSessionDataTask?, error: Error?) {
    handle(error: error, title: "Imgur Upload Failed")
  }
  
  // MARK: IMGSessionDelegate
  
  func imgurRequestFailed(_ error: Error!) {
    handle(error: error, title: "Imgur Request Failed")
  }
  
  func imgurSessionRateLimitExceeded() {
    print("imgurSessionRateLimitExceeded")
    UserNotificationController.shared
      .displayNotification(withTitle: "Imgur Rate Limit Exceeded",
                           informativeText: "Further Imgur requests may fail")
  }
  
  func imgurSessionNeedsExternalWebview(_ url: URL!, completion: (() -> Void)!) {
    externalWebViewCompletionHandler = completion
    NSWorkspace.shared.open(url)
  }
  
  func imgurSessionUserRefreshed(_ user: IMGAccount!) {
    print("imgurSessionUserRefreshed")
    
    guard let username = user.username,
      let refreshToken = IMGSession.sharedInstance().refreshToken else {
        return
    }
    
    if UserDefaults.standard.string(forKey: refreshTokenKey) == nil {
      UserNotificationController.shared
        .displayNotification(withTitle: "Authentication Succeeded",
                             informativeText: "Signed in as \(username)")
    }
    
    UserDefaults.standard.set(refreshToken, forKey: refreshTokenKey)
  }
  
  // MARK: External WebView Handler
  
  func handleExternalWebViewEvent(withResponseURL url: URL) {
    guard let query = url.query?.components(separatedBy: "&") else {
      NSLog("Unable to find URL query component: \(url)")
      return
    }
    
    for parameter in query {
      let pair = parameter.components(separatedBy: "=")
      
      if pair.count == 2 && pair[0] == "code" {
        IMGSession.sharedInstance().authenticate(withCode: pair[1])
        externalWebViewCompletionHandler?()
        externalWebViewCompletionHandler = nil
        return
      }
    }
  }
  
}

