//
//  ContentView.swift
//  WordIt
//
//  Created by Conner Tate on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    
    //MODEL DATA
    @ObservedObject var model = ViewModel(matrixSize: 8, poolSize: 24, numOfLetters: 8)
    
    //VARIABLES
    @State var showingSettings = false
    
    var body: some View {
        ZStack {
            
            //BACKGROUND
            Image("paper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            //MAIN VSTACK
            VStack(spacing: 5) {
                
                //SETTINGS BUTTON
                HStack() {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Color(0x92CADA))
                        .padding(.leading, 300)
                        .onTapGesture {
                            showingSettings = true
                        }
                }
                .padding()
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
                
                HStack(spacing: 0) {
                    //TITLE TEXT
                    HStack(spacing:  10) {
                        TitleLetter(letter: "W", color: "blue")
                        TitleLetter(letter: "O", color: "blue")
                        TitleLetter(letter: "R", color: "blue")
                        TitleLetter(letter: "D", color: "blue")
                        
                        TitleLetter(letter: "I", color: "green")
                        TitleLetter(letter: "T", color: "green")
                    }
                }
                
                //MATRIX
                VStack(spacing: 4) {
                    HStack(spacing: 4){
                        MatrixLetterView(letter: "A")
                        MatrixLetterView(letter: "B")
                        MatrixLetterView(letter: "C")
                        MatrixLetterView(letter: "D")
                        MatrixLetterView(letter: "E")
                        MatrixLetterView(letter: "F")
                        MatrixLetterView(letter: "G")
                        MatrixLetterView(letter: "H")
                    }
                    HStack(spacing: 4){
                        MatrixLetterView(letter: "A")
                        MatrixLetterView(letter: "B")
                        MatrixLetterView(letter: "C")
                        MatrixLetterView(letter: "D")
                        MatrixLetterView(letter: "E")
                        MatrixLetterView(letter: "F")
                        MatrixLetterView(letter: "G")
                        MatrixLetterView(letter: "H")
                    }
                    HStack(spacing: 4){
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                        MatrixLetterView(letter: "")
                    }
                    
                }
                .padding()
                
                //POOL
                VStack(spacing: 4) {
                    HStack(spacing: 4){
                        ForEach(0..<8) { i in
                            PoolLetterView(model: model, index: i)
                        }
                    }
                    HStack(spacing: 4){
                        ForEach(8..<16) { i in
                            PoolLetterView(model: model, index: i)
                        }
                    }
                    HStack(spacing: 4){
                        ForEach(16..<24) { i in
                            PoolLetterView(model: model, index: i)
                        }
                    }
                }
                .padding()

                //TRASH BUTTON
                Image(systemName: "arrow.triangle.swap")
                    .font(.system(size: 30.0, weight: .bold))
                    .foregroundColor(Color(0xb13c3a))
                    .padding()
                
            }
        }
    }
}

//TITLE LETTER VIEW
struct TitleLetter: View {
    var letter: String
    var color: String
    
    var body: some View {
        ZStack {
            if(color == "blue") {
                Color(0xB6D8E9)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                    .offset(x: -4, y: 4)
                
                Color(0x93CADA)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
            }
            
            if(color == "green") {
                Color(0xBFD1B2)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                    .offset(x: -4, y: 4)
                
                Color(0xADBD8A)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
            }
            
            Text(letter)
                .foregroundColor(.white)
                .font(.system(.largeTitle, design: .rounded))
        }
    }
    
}

//LETTERS FOR MAIN MATRIX
struct MatrixLetterView: View {
    @State var letter: String
    
    var body: some View {
        
        if(letter == "") {
            //EMPTY LETTER
            ZStack {
                
                Color.blue
                    .opacity(0.0)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black
                            .opacity(0.1), lineWidth: 4)
                    }
                
                Text(letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
            }
            .padding(2)
        } else {
            //LETTER PLACED
            ZStack {
                Color(0xAEBC89)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                
                Text(letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
            }
        }
    }
}

//LETTERS FOR USER'S POOL
struct PoolLetterView: View {
    @ObservedObject var model: ViewModel
    var index: Int
    @State var tap = false
    
    //FUNCTIONS
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    var body: some View {
        if(model.pool[index].letter == "") {
            //EMPTY LETTER
            ZStack {
                Color.blue
                    .opacity(0.0)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(0xD0B06F)
                                .opacity(1), lineWidth: 4)
                    }
                
                Text(model.pool[index].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
            }
            .padding(2)
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapPoolCell(cell: model.pool[index])
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
            }
        } else {
            //LETTER PLACED
            ZStack {
                Color(0xD0B06F)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
                
                Text(model.pool[index].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
            }
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapPoolCell(cell: model.pool[index])
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
            }
            
        }
    }
}

//PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//HELPER EXTENSIONS
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
