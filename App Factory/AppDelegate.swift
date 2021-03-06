import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet var buildAppButton: NSButton!
    @IBOutlet var scriptDrop: IAScriptDrop!
    @IBOutlet var iconDrop: IAIconDrop!
    
    @IBAction func buildAppClicked(sender : AnyObject) {
        if self.scriptDrop.scriptPath == nil {
            let alert: NSAlert = NSAlert()
            alert.messageText = "No script selected"
            alert.addButtonWithTitle("OK")
            alert.informativeText = "Please select a script file"
            alert.runModal()
            return
        }
        
        let savePanel = NSSavePanel()
        savePanel.extensionHidden = true
        savePanel.allowsOtherFileTypes = false
        savePanel.allowedFileTypes = ["app"]
        savePanel.nameFieldStringValue = self.scriptDrop.scriptPath.URLByDeletingPathExtension!.lastPathComponent!
            
        savePanel.beginWithCompletionHandler({ response in
            if response == NSFileHandlingPanelOKButton {
                let converter = ScriptConverter(
                    scriptPath: self.scriptDrop.scriptPath,
                    savePath: savePanel.URL!,
                    iconPath: self.iconDrop.iconPath
                )
                
                do {
                    try converter!.createApp();
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication) -> Bool {
        return true;
    }
}

