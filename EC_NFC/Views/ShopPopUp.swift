//
//  ShopPopUp.swift
//  EC_NFC
//
//  Created by Egor Dadugin on 19.08.2022.
//

import SwiftUI

struct ShopPopUp: View {
    @ObservedObject var nfcWriter: NFCWriter
    //@State var moneyAmount: String = ""
    @Binding var show: Bool
    var body: some View {
        if show {
            VStack {
                Text("Shop")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45, alignment: .center)
                    .font(.system(size: 30))
                TextField("Enter the amount of money", text: $nfcWriter.messageText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45, alignment: .center)
                    .font(.system(size: 20))
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                Button(action: {
                    show.toggle()
                    nfcWriter.mode = .take
                    nfcWriter.beginWrite()
                },
                       label: {
                    Text("OK")
                        .font(.system(size: 25))
                })
                .padding(.vertical)
            }.frame(maxWidth: 300)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray, lineWidth: 2))
        }
    }
}

struct ShopPopUp_Previews: PreviewProvider {
    @ObservedObject private static var nfcWriter: NFCWriter = NFCWriter()
    @State private static var showPreview: Bool = true
    static var previews: some View {
        ShopPopUp(nfcWriter: nfcWriter, show: $showPreview)
    }
}
