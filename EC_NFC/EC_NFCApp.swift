//
//  EC_NFCApp.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 17.05.2022.
//

import SwiftUI
import Firebase

@main
struct EC_NFCApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            //MenuView()
        }
    }
}
