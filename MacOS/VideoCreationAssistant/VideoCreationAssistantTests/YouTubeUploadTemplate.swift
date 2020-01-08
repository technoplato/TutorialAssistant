
struct YouTubeUploadScriptBuilder {

  static func build(clipDir: String, youtubeClassicUploadUrl: String) -> String {
    return """
    activate application "Safari Technology Preview"
    tell application "Safari Technology Preview"
    tell document 1
    set the URL to "\(youtubeClassicUploadUrl)"
    
    delay 2
    
    do JavaScript "document.getElementById('start-upload-button-single').click()"
    end tell
    end tell
    
    tell application "System Events"
    keystroke "G" using {command down, shift down}
    delay 1
    keystroke "\(clipDir)"
    delay 1
    keystroke return
    delay 1
    key code 124
    delay 1
    keystroke "a" using {command down}
    delay 1
    keystroke return
    
    tell application "Safari Technology Preview"
    tell document 1
    
    delay 2
    do JavaScript "document.getElementById('bulk-privacy-selector').click()"
    delay 2
    do JavaScript "document.getElementsByClassName('bulk-set-privacy-unlisted')[0].click()"
    delay 2
    do JavaScript "document.getElementsByClassName('expand-button-text).forEach(d => d.click())"
    delay 2
    set myVar to do JavaScript "
    
    [...document.getElementsByClassName('upload-item')].map(uploadItem => {
    // Expand all uploads
    uploadItem.getElementsByClassName('expand-button-text')[0].click()
    
    const title = uploadItem.getElementsByClassName('video-settings-title')[0].value
    const nodes = uploadItem.querySelector('.watch-page-link, a').childNodes
    if (nodes.length > 1) {
    return {
    youtubeUrl: nodes[1].text,
    title: title
    }
    } else {
    return {}
    }
    })
    
    "
    return myVar
    end tell
    end tell
    end tell
    """
  }
}
