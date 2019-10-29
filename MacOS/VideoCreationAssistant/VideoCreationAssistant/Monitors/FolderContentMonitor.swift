//
//  FolderContentMonitor.swift
//  TutorialAssistant
//
//  Created by Michael Lustig on 9/29/19.
//  Copyright © 2019 lustig. All rights reserved.
//

import Foundation

public struct Event: CustomStringConvertible {

    public let eventId: FSEventStreamEventId
    public let path: String
    public let eventFlags: FSEventStreamEventFlags

    public var description: String {
        return "\(eventId) - \(eventFlags) - \(path)"
    }
}

public class FolderContentMonitor {

    let callback: (Event) -> Void

    public init(pathsToWatch: [String], sinceWhen: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow), callback: @escaping (Event) -> Void) {

        self.lastEventId = sinceWhen
        self.pathsToWatch = pathsToWatch
        self.callback = callback
    }

    deinit {
        stop()
    }

    // MARK: - Private Properties
    private let eventCallback: FSEventStreamCallback = {
        (stream: ConstFSEventStreamRef,
        contextInfo: UnsafeMutableRawPointer?,
        numEvents: Int,
        eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>,
        eventIds: UnsafePointer<FSEventStreamEventId>) in

        let fileSystemWatcher: FolderContentMonitor = unsafeBitCast(contextInfo, to: FolderContentMonitor.self)

        guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }

        for index in 0..<numEvents {
            fileSystemWatcher.processEvent(eventId: eventIds[index], eventPath: paths[index], eventFlags: eventFlags[index])
        }

        fileSystemWatcher.lastEventId = eventIds[numEvents - 1]
    }

    private let pathsToWatch: [String]
    private var started = false
    private var streamRef: FSEventStreamRef!

    private func processEvent(eventId: FSEventStreamEventId, eventPath: String, eventFlags: FSEventStreamEventFlags) {

        let event = Event(eventId: eventId, path: eventPath, eventFlags: eventFlags)
        callback(event)
    }

    public private(set) var lastEventId: FSEventStreamEventId

    public func start() {
        guard started == false else { return }

        var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()
        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
        streamRef = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)

        FSEventStreamScheduleWithRunLoop(streamRef, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
        FSEventStreamStart(streamRef)

        started = true
    }

    public func stop() {
        guard started == true else { return }

        FSEventStreamStop(streamRef)
        FSEventStreamInvalidate(streamRef)
        FSEventStreamRelease(streamRef)
        streamRef = nil

        started = false
    }
}
