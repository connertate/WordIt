//
//  ContentView.swift
//  WordIt
//
//  Created by Conner Tate on 5/14/22.
//

//CUSTOM FONTS https://betterprogramming.pub/custom-fonts-in-swiftui-d529de69131d

import SwiftUI
struct ContentView: View {
    
    //MODEL DATA
    @ObservedObject var model = ViewModel(matrixSize: 8, poolSize: 24, numOfLetters: 21)
    
    //VARIABLES
    @State var showingInstructions = false
    
    var body: some View {
        ZStack {
            
            //BACKGROUND
            Image("paper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Color(0xFCF5E5)
                .opacity(0.75)
                .ignoresSafeArea()
            
            //CREDITS & SETTINGS COG
            VStack {
                //SETTINGS COG BUTTON
                HStack() {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(Color(0x92CADA))
                        .padding(.leading, 300)
                        .onTapGesture {
                            model.showingSettings = true
                        }
                }
                .padding()
                .sheet(isPresented: $model.showingSettings) {
                    SettingsView(model: model)
                }
                
                Spacer()
                
                //CREDITS
                if(!model.playingGame) {
                    HStack(spacing: 0) {
                        Text("made by")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading) {
                            Text("🙇🏻‍♀️maddie fetsko")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                            
                            Text("🙇🏻conner tate")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 15)
                        
                        Text("2022")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.black)
                    }
                }
            }
            
            //MAIN VSTACK
            VStack(spacing: 5) {
                
                HStack(spacing: 0) {
                    //TITLE TEXT
                    HStack(spacing:  7) {
                        TitleLetter(letter: "W", color: "blue")
                        TitleLetter(letter: "O", color: "blue")
                        TitleLetter(letter: "R", color: "blue")
                        TitleLetter(letter: "D", color: "blue")
                        
                        TitleLetter(letter: "I", color: "green")
                        TitleLetter(letter: "T", color: "green")
                    }
                }
                
                //START GAME BUTTON
                if(!model.playingGame){
                    BarButton(text: "PLAY")
                        .onTapGesture {
                            withAnimation(.spring()) {
                                model.playingGame = true
                            }
                            
                        }
                        .padding(.top, 30)
                }
                
                //START GAME BUTTON
                if(!model.playingGame){
                    BarButton(text: "INSTRUCTIONS")
                        .onTapGesture {
                            showingInstructions.toggle()
                        }
                        .padding()
                        .sheet(isPresented: $showingInstructions) {
                            //INSTRUCTIONS VIEW
                            InstructionsView()
                        }
                }
                
                //MATRIX
                if(model.playingGame) {
                    VStack(spacing: 0) {
                        ForEach(0..<8) { i in
                            HStack(spacing: 0){
                                ForEach(0..<8) { j in
                                    MatrixLetterView(model: model, i: i, j: j)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 30)
                }
                
                //POOL
                if(model.playingGame) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0){
                            ForEach(0..<8) { i in
                                PoolLetterView(model: model, index: i)
                            }
                        }
                        HStack(spacing: 0){
                            ForEach(8..<16) { i in
                                PoolLetterView(model: model, index: i)
                            }
                        }
                        HStack(spacing: 0){
                            ForEach(16..<24) { i in
                                PoolLetterView(model: model, index: i)
                            }
                        }
                    }
                }
                
                //TRASH BUTTON
                if(model.playingGame) {
                    SwapButton(model: model)
                }
                
            }
            
            //WIN LABEL
            ZStack {
                Color(0xB6D8E9)
                    .frame(width: 350, height: 185)
                    .cornerRadius(10)
                
                VStack() {
                    HStack(spacing:  7) {
                        TitleLetter(letter: "W", color: "green")
                        TitleLetter(letter: "I", color: "green")
                        TitleLetter(letter: "N", color: "green")
                        TitleLetter(letter: "N", color: "green")
                        TitleLetter(letter: "E", color: "green")
                        TitleLetter(letter: "R", color: "green")
                    }
                    .padding()
                    
                    BarButton(text: "New Game")
                        .onTapGesture {
                            model.newGame()
                            model.gameWon = false
                        }
                }
            }
            .animation(.spring(), value: model.gameWon)
            .offset(x: 0, y: model.gameWon ? 0 : 750)
        }
    }
}

//INSTRUCTIONS VIEW
struct InstructionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("paper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Color(0x93CADA)
                .opacity(0.75)
                .ignoresSafeArea()
            
            VStack(spacing: 6) {
                //TITLE TEXT
                HStack(spacing: 6) {
                    TitleLetter(letter: "H", color: "green")
                    TitleLetter(letter: "O", color: "green")
                    TitleLetter(letter: "W", color: "green")
                        .padding(.trailing, 15)
                    
                    TitleLetter(letter: "T", color: "green")
                    TitleLetter(letter: "O", color: "green")
                }
                .padding(.top, 50)
                
                //TITLE TEXT
                HStack(spacing: 6) {
                    TitleLetter(letter: "P", color: "green")
                    TitleLetter(letter: "L", color: "green")
                    TitleLetter(letter: "A", color: "green")
                    TitleLetter(letter: "Y", color: "green")
                }
                .padding()

                
                HStack() {
                    TitleLetter(letter: "1", color: "tan")

                    Text("Use the given letters to create a crossword using the 8x8 grid.")
                        .frame(width: 300)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding()
                
                HStack {
                    TitleLetter(letter: "2", color: "tan")

                    Text("Use the swap button to exchange an unwanted letter for two new ones. Max of three swaps per game.")
                        .frame(width: 300)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding()
                
                HStack {
                    TitleLetter(letter: "3", color: "tan")

                    Text("Words must be real and touching in order to win.")
                        .frame(width: 300)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding()
                    
                BarButton(text: "OK")
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.top, 50)
                
                Spacer()
            }
        }
    }
}

//TITLE LETTER VIEW
struct SwapButton: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        ZStack {
            Image(systemName: "arrow.triangle.swap")
                .font(.system(size: 45.0, weight: .bold))
                .foregroundColor(Color(0xb13c3a))
                .padding()
            
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(0xFCF5E5))
                .opacity(0.75)
            
            if(model.replacesLeft == 3) {
                Image(systemName: "3.circle")
                    .font(.system(size: 20.0, weight: .bold))
                    .foregroundColor(Color(0xb13c3a))
                    .foregroundColor(Color(.yellow))
                    .offset(x: 0, y: 0)
            }
            
            if(model.replacesLeft == 2) {
                Image(systemName: "2.circle")
                    .font(.headline)
                    .foregroundColor(Color(0xb13c3a))
                    .offset(x: 0, y: 0)
            }
            
            if(model.replacesLeft == 1) {
                Image(systemName: "1.circle")
                    .font(.headline)
                    .foregroundColor(Color(0xb13c3a))
                    .offset(x: 0, y: 0)
            }
            
            if(model.replacesLeft == 0) {
                Image(systemName: "0.circle")
                    .font(.headline)
                    .foregroundColor(Color(0xb13c3a))
                    .offset(x: 0, y: 0)
            }
        }
        .onTapGesture {
            if(model.selectedCellIndex != nil && model.replacesLeft > 0) {
                model.replaceCell()
            }
        }
        .opacity((model.selectedCellIndex != nil && model.replacesLeft > 0) ? 1 : 0.25)
        .animation(.spring(), value: model.selectedCellIndex)
        .animation(.spring(), value: model.replacesLeft)
    }
}

//TITLE LETTER VIEW
struct TitleLetter: View {
    var letter: String
    var color: String
    
    var body: some View {
        ZStack {
            if(color == "blue") {
//                Color(0xB6D8E9)
//                    .frame(width: 44, height: 44)
//                    .cornerRadius(8)
//                    .offset(x: -4, y: 4)
                
                Color(0x93CADA)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
            }
            
            if(color == "green") {
//                Color(0xBFD1B2)
//                    .frame(width: 44, height: 44)
//                    .cornerRadius(8)
//                    .offset(x: -4, y: 4)
                
                Color(0xADBD8A)
                    .frame(width: 44, height: 44)
                    .cornerRadius(8)
            }
            
            if(color == "tan") {
//                Color(0xD0B06F)
//                    .frame(width: 44, height: 44)
//                    .cornerRadius(8)
//                    .offset(x: -4, y: 4)
//
//                Color(.white)
//                    .frame(width: 44, height: 44)
//                    .cornerRadius(8)
//                    .offset(x: -4, y: 4)
//                    .opacity(0.25)
                
                Color(0xD0B06F)
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
    
    @ObservedObject var model: ViewModel
    var i: Int
    var j: Int
    @State var tap = false
    
    //FUNCTIONS
    func simpleSuccess() {
        if(model.vibrateOn) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    var body: some View {
        
        if(model.matrix[i][j].letter == "") {
            //EMPTY LETTER
            ZStack {
                //ADDED FOR TAP DETECTION
                Color(.red)
                    .frame(width: 42, height: 42)
                    .opacity(0.0)
                
                Color.blue
                    .opacity(0.0)
                    .frame(width: 36, height: 36)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(0xD0B06F)
                            .opacity(0.25), lineWidth: 4)
                    }
                
                Text(model.matrix[i][j].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
            }
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.3), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapCell(cellIndex: [i, j])
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
            }
        } else {
            //LETTER PLACED
            ZStack {
                //ADDED FOR TAP DETECTION
                Color(.red)
                    .frame(width: 42, height: 42)
                    .opacity(0.0)
                
                Color(model.matrix[i][j].selected ? 0x93CADA : 0xD0B06F)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                Color(0xADBD8A)
                    .opacity((model.matrix[i][j].inValidWord && !model.matrix[i][j].selected) ? 1 : 0)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                Text(model.matrix[i][j].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
            }
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.3), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapCell(cellIndex: [i, j])
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
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
                //ADDED FOR TAP DETECTION
                Color(0xD0B06F)
                    .frame(width: 42, height: 42)
                    .opacity(0)
                
                Color.blue
                    .opacity(0.0)
                    .frame(width: 36, height: 36)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(0xD0B06F)
                                .opacity(0.25), lineWidth: 4)
                    }
                
                Text(model.pool[index].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
            }
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.3), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapCell(cellIndex: [index])
                tap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    tap = false
                }
            }
        } else {
            //LETTER PLACED
            ZStack {
                //ADDED FOR TAP DETECTION
                Color(.red)
                    .frame(width: 42, height: 42)
                    .opacity(0.0)
                
                Color(model.pool[index].selected ? 0x93CADA : 0xD0B06F)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                Text(model.pool[index].letter)
                    .foregroundColor(.white)
                    .font(.system(.largeTitle, design: .rounded))
            }
            .scaleEffect(tap ? 0.85 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.3), value: tap)
            .onTapGesture {
                simpleSuccess()
                model.tapCell(cellIndex: [index])
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
