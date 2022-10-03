//
//  MainView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 15.07.2022.
//

import SwiftUI
import CoreNFC

struct MainView: View {
    @ObservedObject var reader = NFCReader()
    @ObservedObject var writer = NFCWriter()
    @ObservedObject var loginManager: LoginManager
    
    let valueOptions = (1...10).map{"\($0)"}
//    var testNFC = NFCTest()
    @State var data: String = "No data scanned yet"
    var body: some View {
        VStack {
            VStack (alignment: .center, spacing: 25) {
            Text("Balance")
                .font(.system(size: 36).bold())
            Text(data)
                .font(.system(size: 25))
            }.padding()
            
            Spacer()
            
            TextField("Enter value", text: $writer.messageText)
                .textFieldStyle(.roundedBorder)
                .padding()
//            Picker("Value picker", selection: $writer.messageText) {
//                ForEach(valueOptions, id: \.self) { value in
//                    Text(value)
//                }
//            }.pickerStyle(.menu)
//            Text(data)
            Button(action: reader.scan
                   , label: {
                Text("Scan")
                    .foregroundColor(.white)
            }
            )
            .frame(width: 200, height: 50, alignment: .center)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            
            Button(action: writer.beginWrite
                   , label: {
                Text("Add cash")
                    .foregroundColor(.white)
            }
            )
            .frame(width: 200, height: 50, alignment: .center)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            
            Button(action: writer.beginWrite
                   , label: {
                Text("Take cash")
                    .foregroundColor(.white)
            }
            )
            .frame(width: 200, height: 50, alignment: .center)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            
            Button(action: loginManager.performLogout
                   , label: {
                Text("Logout")
                    .foregroundColor(.white)
            }
            )
            .frame(width: 200, height: 50, alignment: .center)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            
            Spacer()
            
        }.onChange(of: reader.data) { newData in
            self.data = reader.data
            writer.data = reader.data
        }.navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(loginManager: LoginManager())
    }
}
