//
//  TeamLeaderView.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 25.08.2022.
//

import SwiftUI

struct TeamLeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var nfcReder: NFCReader = NFCReader()
    @ObservedObject var nfcWriter: NFCWriter = NFCWriter()
    @ObservedObject var loginManager = LoginManager.shared
    @State var leaderBalance: String = "0"
    @State var scannedBalance: String = "No balance scanned"
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                Text("Team Leader")
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
                Text("Your Balance: \(leaderBalance)")
                    .font(.system(size: 24))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text("Balance on scanned card: \(scannedBalance)")
                    .font(.system(size: 24))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 50) {
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
                        nfcWriter.mode = .take
                        nfcWriter.messageText = scannedBalance
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
                            Text("Take money")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    })
                    
                    Button(action: {
                        nfcWriter.mode = .add
                        nfcWriter.messageText = leaderBalance
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
                                    .frame(minWidth: 0, idealWidth: 80 , maxWidth: 80, minHeight: 0, idealHeight: 40, maxHeight: 40, alignment: .center)
                            }
                            Text("Add money")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    })
                }
                
                Spacer()
            }.onChange(of: nfcReder.data) { newData in
                self.scannedBalance = newData
                nfcWriter.data = newData
            }
            .onChange(of: nfcWriter.changeLeaderBalance) { newData in
                if nfcWriter.changeLeaderBalance {
                    switch nfcWriter.mode {
                    case .take:
                        self.leaderBalance = self.scannedBalance
                    case . add:
                        self.leaderBalance = "0"
                    default:
                        break
                    }
                    self.scannedBalance = "0"
                    nfcWriter.changeLeaderBalance = false
                }
            }
        }
    }
}

struct TeamLeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TeamLeaderView()
    }
}
