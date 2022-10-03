//
//  NFCCollector.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 21.08.2022.
//

import Foundation
import CoreNFC

class NFCCollector: NSObject, NFCNDEFReaderSessionDelegate, ObservableObject {
    var session: NFCNDEFReaderSession?
    @Published var data: String = ""
    
    func beginCollection() {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your phone near NFC Tag"
        session?.begin()
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                case .readWrite:
                    tag.readNDEF(completionHandler: {(message: NFCNDEFMessage?, error: Error?) in
                        var statusMessage: String
                        if nil != error || nil == message {
                            statusMessage = "Fail to read NDEF from tag"
                        } else {
                            statusMessage = "Found 1 NDEF message"
                            DispatchQueue.main.async {
                                // Process detected NFCNDEFMessage objects.
                                self.data = String(data: (message?.records.first?.payload)!, encoding: .utf8)!
                                print(self.data)
                            }
                        }
                        
                        session.alertMessage = statusMessage
                        session.invalidate()
                    })
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            })
        })
    }
    
}
