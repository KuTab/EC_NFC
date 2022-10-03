//
//  StagerView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 25.08.2022.
//

import SwiftUI

struct StagerView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var loginManager = LoginManager.shared
    @ObservedObject var nfcReder: NFCReader = NFCReader()
    @ObservedObject var nfcWriter: NFCWriter = NFCWriter()
    @State var showPopUp: Bool = false
    @State var balance: String = "No balance scanned"
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                Text("Stager")
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
                Text("Balance: \(balance)")
                    .font(.system(size: 24))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 100) {
                Button(action: nfcReder.scan,
                       label: {
                VStack {
                    ZStack {
                        Circle()
                            .foregroundColor(.blue)
                            .frame(minWidth: 0, idealWidth: 135, maxWidth: 135, minHeight: 0, idealHeight: 135, maxHeight: 135, alignment: .center)
                        Image(systemName: "person.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(minWidth: 0, idealWidth: 50, maxWidth: 50, minHeight: 0, idealHeight: 50, maxHeight: 50, alignment: .center)
                    }
                    Text("Scan")
                        .font(.system(size: 25))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                })
                
                    Button(action: {
                        nfcWriter.messageText = "1"
                        nfcWriter.mode = .add
                        nfcWriter.beginWrite()
                    }, label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(minWidth: 0, idealWidth: 135, maxWidth: 135, minHeight: 0, idealHeight: 135, maxHeight: 135, alignment: .center)
                                Image(systemName: "banknote.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(minWidth: 0, idealWidth: 80, maxWidth: 80, minHeight: 0, idealHeight: 40, maxHeight: 40, alignment: .center)
                            }
                            Text("Stager")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    })
                }
                
                Spacer()
                
            }.onChange(of: nfcReder.data) { newData in
                self.balance = newData
                nfcWriter.data = newData
            }
        }
    }
}

struct StagerView_Previews: PreviewProvider {
    static var previews: some View {
        StagerView()
    }
}
