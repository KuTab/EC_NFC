//
//  AdminView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 22.08.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct AdminView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var loginManager = LoginManager.shared
    let rolesVariants: [String] = ["admin", "stager", "shop", "teamLeader"]
    @State var email: String = ""
    @State var password: String = ""
    @State var role: String = ""
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                
                Text("Admin pannel")
                .font(.system(size: 36))
                .bold()
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity)
                
                Button(action: loginManager.performLogout,
                       label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .center)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
            }
            
            Spacer()
            
            TextField("Enter email", text: $email)
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
            TextField("Enter password", text: $password)
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
            HStack {
                Text("Pick a role:")
                
                Spacer()
                
                Picker("Pick a role", selection: $role) {
                    ForEach(rolesVariants, id: \.self) { roleName in
                        Text(roleName)
                    }
                }.pickerStyle(.menu)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Button(action: createUser,
                   label: {
                Text("Create")
                    .foregroundColor(.white)
                    .frame(maxWidth: 200, maxHeight: 50, alignment: .center)
                    .background(.blue)
                    .cornerRadius(10)
            })
            
            Spacer()
        }
    }
    
    func createUser() {
        Auth.auth().createUser(withEmail: email, password: password)
        let db = Firestore.firestore()
        let data: [String: Any] = ["role" : role]
        db.collection("roles").document(email).setData(data) {error in
            if let error = error {
                print("Error writing user role: \(error)")
            } else {
                print("Success writing user role")
            }
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
