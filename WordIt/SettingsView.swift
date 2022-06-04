//
//  SettingsView.swift
//  WordIt
//
//  Created by Conner Tate on 6/4/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(0x92CADA)
                .ignoresSafeArea()
            
            Image("paper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .opacity(1)
            
            VStack {
                HStack{
                    Text("SETTINGS")
                        .font(.system(size: 40, design: .rounded))
                        .font(.system(size: 50, design: .rounded))
                        .foregroundColor(Color(0x92CADA))

                    Text("BITCH")
                        .font(.system(size: 40, design: .rounded))
                        .font(.system(size: 50, design: .rounded))
                        .foregroundColor(Color(0xAEBC89))

                }
                .padding()
                
                
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
