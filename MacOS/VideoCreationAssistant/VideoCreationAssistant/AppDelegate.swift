//
//  AppDelegate.swift
//  VideoCreationAssistant
//
//  Created by Michael Lustig on 10/28/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Cocoa
import OAuth2
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let popover = NSPopover()
  let recordingManager = RecordingManager()
  let oa = OAuth()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSAppleEventManager.shared().setEventHandler(
      self,
      andSelector: #selector(AppDelegate.handleURLEvent(_:withReply:)),
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
    
    // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
    // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
    let contentView = RecordingView().environment(\.managedObjectContext, persistentContainer.viewContext).environmentObject(recordingManager)
    ImgurClient.shared.setup()

    // Create the window and set the content view. 
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
    
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
      button.action = #selector(togglePopover(_:))
    }
    
//    constructMenu()
//    popover.contentViewController = NSHostingController(rootView: DetailsView().environmentObject(recordingManager))
  }

  
  /** Gets called when the App launches/opens via URL. */
  @objc func handleURLEvent(_ event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
    print("handleURLEvent")
  
    if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue {
      print(urlString)
      if let url = URL(string: urlString), "com.lustig.videocreationassistant" == url.scheme {
        oa.oauth2.handleRedirectURL(url)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OAuth2AppDidReceiveCallback"), object: url)
      }
    }
    else {
      NSLog("No valid URL to handle")
    }
  }
  
  
  func promptScreenshotDetails() {
    if let button = statusItem.button {
      self.showPopover(sender: button)
    }
  }
  
  func hideScreenshotDetails() {
    if let button = statusItem.button {
      self.closePopover(sender: button)
    }
  }
  
  // MARK: Ray Wenderlich
  
  @objc func printQuote(_ sender: Any?) {
    print("Clicked status bar item!")
  }
  
  func constructMenu() {
    let menu = NSMenu()
    
    menu.addItem(NSMenuItem(title: "Print 1", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit Assistant", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    
    statusItem.menu = menu
  }
  
  @objc func togglePopover(_ sender: Any?) {

    self.oa.oauth2.authorize { (json, error) in
      print(json)
      print(error)
    }
  }
  
  func showPopover(sender: Any?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
  }
  
  func closePopover(sender: Any?) {
    popover.performClose(sender)
  }
  
  // MARK: Core Data

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "VideoCreationAssistant")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving and Undo support

  @IBAction func saveAction(_ sender: AnyObject?) {
      // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
      let context = persistentContainer.viewContext

      if !context.commitEditing() {
          NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
      }
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Customize this code block to include application-specific recovery steps.
              let nserror = error as NSError
              NSApplication.shared.presentError(nserror)
          }
      }
  }

  func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
      // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
      return persistentContainer.viewContext.undoManager
  }

  func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
      // Save changes in the application's managed object context before the application terminates.
      let context = persistentContainer.viewContext
      
      if !context.commitEditing() {
          NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
          return .terminateCancel
      }
      
      if !context.hasChanges {
          return .terminateNow
      }
      
      do {
          try context.save()
      } catch {
          let nserror = error as NSError

          // Customize this code block to include application-specific recovery steps.
          let result = sender.presentError(nserror)
          if (result) {
              return .terminateCancel
          }
          
          let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
          let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
          let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
          let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
          let alert = NSAlert()
          alert.messageText = question
          alert.informativeText = info
          alert.addButton(withTitle: quitButton)
          alert.addButton(withTitle: cancelButton)
          
          let answer = alert.runModal()
          if answer == .alertSecondButtonReturn {
              return .terminateCancel
          }
      }
      // If we got here, it is time to quit.
      return .terminateNow
  }

}

