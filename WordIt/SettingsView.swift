//
//  SettingsView.swift
//  WordIt
//
//  Created by Conner Tate on 6/4/22.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @State var soundOn = true
    @State var vibrateOn = false
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Color(0x93CADA)
                .ignoresSafeArea()
                .opacity(0.75)
            
            
            
            VStack(spacing: 0) {
                
                //TITLE TEXT
                HStack(spacing: 6) {
                    TitleLetter(letter: "O", color: "green")
                    TitleLetter(letter: "P", color: "green")
                    TitleLetter(letter: "T", color: "green")
                    TitleLetter(letter: "I", color: "green")
                    TitleLetter(letter: "O", color: "green")
                    TitleLetter(letter: "N", color: "green")
                    TitleLetter(letter: "S", color: "green")
                }
                .padding(100)

                //BAR BUTTONS
                BarButton(text: "Reset")
                    .padding(5)
                
                BarButton(text: "New Game")
                    .padding(5)
                
                //TOGGLE BUTTONS
                HStack(spacing: 50) {
                    VStack(spacing: 5) {
                        Text("Sound")
                            .foregroundColor(.white)
                            .bold()
                            .font(.headline)
                
                        SquareToggle(val: $soundOn)
                    }
                    
                    VStack(spacing: 5) {
                        Text("Vibration")
                            .foregroundColor(.white)
                            .bold()
                            .font(.headline)
                        
                        SquareToggle(val: $vibrateOn)
                    }
                }
                .padding(25)
                
                Spacer()
            }
        }
    }
}

struct BarButton: View {
    var text: String
    
    var body: some View {
        ZStack {
            Color.white
                .frame(width: 250, height: 50)
                .cornerRadius(7)
            
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(Color(0x93CADA))
        }
    }
}

struct SquareToggle: View {
    @Binding var val: Bool
    var offset: CGFloat {
        if(val){
            return -25.0
        } else {
            return 25.0
        }
    }
    
    //FUNCTIONS
    func simpleSuccess() {
        //PLAY SOUND
        AudioServicesPlaySystemSound(SystemSoundID(1105))
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    var body: some View {
        ZStack {
            Color(0xADBD8A)
                .frame(width: 100, height: 50)
                .cornerRadius(7)
                .opacity(val ? 0 : 1)
            
            Color.white
                .frame(width: 100, height: 50)
                .cornerRadius(7)
                .opacity(!val ? 0 : 1)
            
            
            Color(0xADBD8A)
                .frame(width: 35, height: 35)
                .cornerRadius(5)
                .offset(x: offset)
                .opacity(!val ? 0 : 1)
            
            Color.white
                .frame(width: 35, height: 35)
                .cornerRadius(5)
                .offset(x: offset)
                .opacity(val ? 0 : 1)
            
            Image(systemName: "checkmark")
                .font(Font.system(size: 20, weight: .black))
                .foregroundColor(.white)
                .opacity(val ? 0 : 1)
                .offset(x: -20)
            
            Image(systemName: "xmark")
                .font(Font.system(size: 20, weight: .black))
                .foregroundColor(Color(0xADBD8A))
                .opacity(!val ? 0 : 1)
                .offset(x: 20)
        }
        .onTapGesture {
            simpleSuccess()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                val.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
