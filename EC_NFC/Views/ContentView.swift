//
//  ContentView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 17.05.2022.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
    @StateObject var loginManager = LoginManager.shared
    
    var body: some View {
        if loginManager.loggedIn {
            switch loginManager.role {
            case "admin":
                AdminView()
            case "stager":
                StagerView()
            case "teamLeader":
                TeamLeaderView()
            case "shop":
                ShopView()
            default:
                LoginView(loginManager: loginManager)
            }
        } else {
            LoginView(loginManager: loginManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .preferredColorScheme(.dark)
    }
}
