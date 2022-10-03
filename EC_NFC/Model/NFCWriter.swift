//
//  NFCWriter.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 20.05.2022.
//

import Foundation
import CoreNFC

enum NFCWriterMode {
    case add
    case take
    case write
}

class NFCWriter: NSObject, NFCNDEFReaderSessionDelegate, ObservableObject {
    var session: NFCNDEFReaderSession?
    @Published var messageText: String = ""
    @Published var data: String = ""
    @Published var changeLeaderBalance = false
    var tempTags: [NFCNDEFTag] = []
    var mode: NFCWriterMode = .add
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        
    }
    
    func beginWrite() {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near an NDEF tag to write the message."
        session?.begin()
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
                    
                    if self.mode == .write {
                        let message: NFCNDEFMessage = .init(records: [NFCNDEFPayload(format: .nfcWellKnown, type: Data(), identifier: Data(), payload: self.messageText.data(using: .utf8)!)])
                        tag.writeNDEF(message, completionHandler: { (error: Error?) in
                            if nil != error {
                                session.alertMessage = "Write NDEF message fail: \(error!)"
                            } else {
                                session.alertMessage = "Write NDEF message successful."
                            }
                            session.invalidate()
                        })
                    } else {
                        
                        var totalBalance: String = ""
                        
                        if self.mode == .add {
                            totalBalance = String(((Int(self.data)) ?? 0) + Int(self.messageText)!)
                            print(totalBalance)
                        } else {
                            if Int(self.data) ?? 0 >= Int(self.messageText)! {
                                totalBalance = String((Int(self.data) ?? 0) - Int(self.messageText)!)
                            } else {
                                //session.alertMessage = "Not enough money on balance"
                                session.invalidate(errorMessage: "Not enough money on balance")
                                break
                            }
                        }
                        
                        let message: NFCNDEFMessage = .init(records: [NFCNDEFPayload(format: .nfcWellKnown, type: Data(), identifier: Data(), payload: totalBalance.data(using: .utf8)!)])
                        
                        tag.writeNDEF(message, completionHandler: { (error: Error?) in
                            if nil != error {
                                session.alertMessage = "Write NDEF message fail: \(error!)"
                            } else {
                                session.alertMessage = "Write NDEF message successful."
                                DispatchQueue.main.async {
                                    self.changeLeaderBalance = true
                                    self.data = ""
                                }
                            }
                            session.invalidate()
                        })
                    }
                    
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                    self.data = ""
                }
            })
        })
    }
}
