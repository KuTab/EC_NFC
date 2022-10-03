//
//  LoginManager.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 15.07.2022.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

final class LoginManager: ObservableObject {
    static let shared = LoginManager()
    
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var loggedIn: Bool = false
    @Published var role: String = ""
    
    func performLogin() {
        //self.loggedIn = true
        print("login")
        Auth.auth().signIn(withEmail: login, password: password) {(result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                let db = Firestore.firestore()
                let rolesRef = db.collection("roles").document(self.login)
                rolesRef.getDocument { (document, erro) in
                    if let document = document, document.exists {
                        if let dataDescription = document.data(){
                            switch dataDescription["role"] as? String {
                            case "admin":
                                self.role = "admin"
                            case "stager":
                                self.role = "stager"
                            case "shop":
                                self.role = "shop"
                            case "teamLeader":
                                self.role = "teamLeader"
                            default:
                                break
                            }
                        }
                        self.loggedIn = true
                        
                    }
                }
            }
        }
    }
    
    func performLogout() {
        print("logout")
        do {
            try Auth.auth().signOut()
            self.loggedIn = false
            self.login = ""
            self.password = ""
        } catch {
            print("error")
        }
    }
}
