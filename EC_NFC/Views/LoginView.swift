//
//  LoginView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 15.07.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginManager: LoginManager
    var body: some View {
        VStack {
            Text("EC NFC App")
                .font(.title.bold())
            Spacer()
            
            VStack {
                VStack {
                    Text("LogIn Form")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.white)
                    TextField("Enter login", text: $loginManager.login)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .colorScheme(.light)
                        .autocapitalization(.none)
                    SecureField("Enter password", text: $loginManager.password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .colorScheme(.light)
                }.frame(minWidth: 100, idealWidth: 360, maxWidth: 360, minHeight: 100, idealHeight: 220, maxHeight: 220, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 4))
                
                Button(action: loginManager.performLogin,
                       label: {
                    Text("Login")
                }).frame(maxWidth: 100, maxHeight: 50)
                    .background(.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.vertical, 30)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(.linearGradient(colors: [Color.cyan, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(30)
            
            Spacer()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginManager: LoginManager())
            .previewInterfaceOrientation(.portrait)
    }
}

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}
