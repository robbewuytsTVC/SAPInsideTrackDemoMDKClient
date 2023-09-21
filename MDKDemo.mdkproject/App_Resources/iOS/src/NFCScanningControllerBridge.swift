import CoreNFC

// Define a class called NFCScanningControlBridge that inherits from NSObject and conforms to NFCTagReaderSessionDelegate
@objc(NFCScanningControlBridge)
public class NFCScanningControlBridge: NSObject,  NFCTagReaderSessionDelegate {

    // Declare a variable to hold the NFCTagReaderSession object
    var session: NFCTagReaderSession?

    // Declare a closure that takes a String and returns Void; used as a callback when NFC is found
    @objc public var onNFCFoundCallback: ((String) -> Void)? = nil
    
    // Initialize the NFCScanningControlBridge object and capture NFC
    public override init() {
        super.init()
        CaptureNFC()
    }
    
    // Function to initiate NFC capturing
    @objc public func CaptureNFC() {
        // Create a new NFCTagReaderSession object with ISO14443 polling option and the current object as delegate
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        
        // Set an alert message to be shown to the user
        self.session?.alertMessage = "Hold your phone near the NFC tag"
        
        // Begin the session
        self.session?.begin()
    }

    // Delegate method called when the NFC session becomes active
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session begun!")
    }

    // Delegate method called when the NFC session is invalidated due to an error
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Error with launching session")
    }

    // Delegate method called when NFC tags are detected
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // Check if more than one tag is detected
        if tags.count > 1{
            session.alertMessage = "More than one tag detected, please try again"
            session.invalidate()
        }
        
        // Get the first detected tag
        let tag = tags.first!
        
        // Try to connect to the tag
        session.connect(to: tag) { (error) in
            if nil != error {
                session.invalidate(errorMessage: "Connection failed")
            }
            
            // If the tag is an MiFare tag
            if case let .miFare(sTag) = tag {
                // Get the UID of the tag and log it
                let UID = sTag.identifier.map { String(format: "%.2hhx", $0) }.joined()
                print(sTag.identifier)
                
                // Invalidate the session
                session.invalidate()
                
                // Trigger the callback function on the main thread with the detected UID
                DispatchQueue.main.async {
                    self.onNFCFoundCallback?(UID)
                }
            }
        }
    }
}
