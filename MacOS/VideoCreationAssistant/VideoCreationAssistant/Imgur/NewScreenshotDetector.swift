import Foundation

typealias NewFileCallback = (_ fileURL: NSURL) -> Void

class ScreenshotDetector: NSObject, NSMetadataQueryDelegate {
    
    let query = NSMetadataQuery()
    
    var newFileCallback: NewFileCallback?

    override init() {
        super.init()
        
        query.delegate = self
        query.predicate = NSPredicate(format: "kMDItemIsScreenCapture = 1")
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(queryUpdated), name: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query)
        center.addObserver(self, selector: #selector(queryUpdated), name: NSNotification.Name.NSMetadataQueryDidUpdate, object: query)
        center.addObserver(self, selector: #selector(queryUpdated), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        
        query.start()
    }
    
    deinit {
        query.stop()
    }
    
    @objc func queryUpdated(notification: NSNotification) {
        print("query updated")
        if let userInfo = notification.userInfo {
            for v in userInfo.values {
                let items = v as! [NSMetadataItem]
                if items.count > 0 {
                    let item = items[0]
                    if let filename = item.value(forAttribute: "kMDItemFSName") as? String {
                        let filenameWithPath = NSString(string: "~/Desktop/" + filename).expandingTildeInPath
                        let url = NSURL(fileURLWithPath: filenameWithPath, isDirectory: false)
                        if let cb = self.newFileCallback {
                            cb(url)
                        }
                    }
                }
            }
        }
    }
}
