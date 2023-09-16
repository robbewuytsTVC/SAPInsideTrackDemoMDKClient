////
////  NFCScanningControl.swift
////  NFCScanningControl
////
////  Created by Robbe Wuyts on 03/04/2023.
////

import UIKit
import CoreNFC

@objc(NFCScanningControlBridge)
public class NFCScanningControlBridge: NSObject,  NFCTagReaderSessionDelegate {

    var session: NFCTagReaderSession?

    @objc public var onNFCFoundCallback: ((String) -> Void)? = nil
    
    public override init() {
        super.init()
        CaptureNFC()
    }
    
    @objc public func CaptureNFC() {
        print("CaptureNFC")
//        self.onNFCFoundCallback = callback
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = "Hold Your Phone Near the NFC Tag"
        self.session?.begin()
    }

    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("Session Begun!")
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Error with Launching Session")
    }

    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        if tags.count > 1{
            session.alertMessage = "More Than One Tag Detected, Please try again"
            session.invalidate()
        }
        let tag = tags.first!
        session.connect(to: tag) { (error) in
            if nil != error{
                session.invalidate(errorMessage: "Connection Failed")
            }
            if case let .miFare(sTag) = tag{
                let UID = sTag.identifier.map{ String(format: "%.2hhx", $0)}.joined()
                print("UID:", UID)
                print(sTag.identifier)
                session.invalidate()
                DispatchQueue.main.async {
                    self.onNFCFoundCallback?(UID);
                }
            }
        }
    }

}
