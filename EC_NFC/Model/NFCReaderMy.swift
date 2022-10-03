//
//  NFCReader.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 20.05.2022.
//

import Foundation
import CoreNFC

class NFCReaderMy: NSObject, NFCTagReaderSessionDelegate, ObservableObject {
    var session: NFCTagReaderSession?
    @Published var data: String
    
    init(data: String){
        self.data = data
    }
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available")
            return
        }
        session = NFCTagReaderSession(pollingOption: [.iso14443], delegate: self)
        session?.alertMessage = "Hold your iPhone near the tag"
        session?.begin()
    }
    
    // Error handling again
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
        self.session = nil
    }
    
    // Additionally there's a function that's called when the session begins
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    // Note that an NFCTag array is passed into this function, not a [NFCNDEFMessage]
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        session.connect(to: tags.first!) { (error : Error?) in
            guard error == nil else {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            print ("Connected to tag")
            
            //            switch tags.first {
            //            case .miFare(let discoveredTag):
            //                print("Got a MiFare tag!", discoveredTag.identifier, discoveredTag.mifareFamily)
            //            case .feliCa(let discoveredTag):
            //                print("Got a FeliCa tag!", discoveredTag.currentSystemCode, discoveredTag.currentIDm)
            //            case .iso15693(let discoveredTag):
            //                print("Got a ISO 15693 tag!", discoveredTag.icManufacturerCode, discoveredTag.icSerialNumber, discoveredTag.identifier)
            //            case .iso7816(let discoveredTag):
            //                print("Got a ISO 7816 tag!", discoveredTag.initialSelectedAID, discoveredTag.identifier)
            //            @unknown default:
            //                session.invalidate(errorMessage: "Unsupported tag!")
            //            }
            //
            
            switch tags.first {
            case .miFare(let newTag):
                newTag.readNDEF(completionHandler: {result, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    print(String(data: (result?.records.first?.payload)!, encoding: .ascii))
                    DispatchQueue.main.async {
                        self.data = String(data: (result?.records.first?.payload)!, encoding: .ascii)!
                        session.invalidate()
                    }
                })

                //session.invalidate()
            default:
                session.invalidate(errorMessage: "Unsupported NFC Tag")
            }
        }
        //session.invalidate()
    }
    
    
}
