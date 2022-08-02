//
//  ViewModel.swift
//  WordIt
//
//  Created by Conner Tate on 5/14/22.
//

import Foundation
import SwiftUI
import AVFoundation

final class ViewModel: ObservableObject{

    //VARIABLES
    @Published var matrix: [[matrixCell]]
    @Published var pool: [matrixCell]
    @Published var selectedCellIndex: [Int]?
    @Published var replacesLeft = 3
    @Published var showingSettings = false
    @Published var numberOfLetters = 0
    @Published var vibrateOn = true
    @Published var soundOn = true
    @Published var gameWon = false
    @Published var playingGame = false
    
     
    //RETUNR RANDOM LETTER
    static func getRandomLetter() -> String {
        let letters = "AAAAAAAAAAAAABBBCCCDDDDDDEEEEEEEEEEEEEEEEEEFFFGGGGHHHIIIIIIIIIIIIJJKKLLLLLMMMNNNNNNNNOOOOOOOOOOOPPPQQRRRRRRRRRSSSSSSTTTTTTTTTUUUUUUVVVWWWXXXZZ"
        return String((0..<1).map{ _ in letters.randomElement()! })
    }
    
    //INITIALIZE
    init(matrixSize: Int, poolSize: Int, numOfLetters: Int) {
        //INIT ARRAYS
        matrix = [[]]
        pool = []
        numberOfLetters = numOfLetters

        //INIT MATRIX
        for i in 0..<matrixSize {
            matrix.append([])
            for _ in 0..<matrixSize {
                matrix[i].append(matrixCell(letter: "", id: UUID()))
            }
        }

        //INIT POOL
        for _ in 0..<poolSize {
            pool.append(matrixCell(letter: "", id: UUID()))
        }
        for i in 0..<numOfLetters {
            pool[i] = matrixCell(letter: ViewModel.getRandomLetter(), id: UUID())
        }
    }
    
    //GET INDEX OF CELL IN THE POOL
    func getPoolCellIndex(id: UUID) -> Int {
        var x = 0
        for cell in pool {
            if(cell.id == id) {
                print("TAPPED \(cell.letter) WITH ID: \(id)")
                return x
            }
            x += 1
        }
        return -1
    }
     
    //POOL CELL TAPPED
    func tapCell(cellIndex: [Int]) {
        //PLAY SOUND
        if(soundOn) {
            AudioServicesPlaySystemSound(SystemSoundID(1105))
        }
        
        var isEmpty = false
        //SET CELL AS SELECTED
        if(cellIndex.count == 1) {
            pool[cellIndex[0]].selected = true
            if(pool[cellIndex[0]].letter == "") {
                isEmpty = true
            }
        } else {
            matrix[cellIndex[0]][cellIndex[1]].selected = true
            if(matrix[cellIndex[0]][cellIndex[1]].letter == "") {
                isEmpty = true
            }
        }
        
        //SEE IF FIRST CELL TAPPED
        if (selectedCellIndex == nil ) {
            if(!isEmpty) {
                selectedCellIndex = cellIndex
            }
        } else {
            //SWAP CELLS
            swapCells(cell1: cellIndex, cell2: selectedCellIndex!)
            //RESET SELECTION
            selectedCellIndex = nil
        }
    }
    
    //SWAP CELLS
    func swapCells(cell1: [Int], cell2: [Int]) {
        //UNSELECT CELLS
        if(cell1.count == 1) {
            pool[cell1[0]].selected = false
        }
        if(cell1.count == 2) {
            matrix[cell1[0]][cell1[1]].selected = false
        }
        if(cell2.count == 1) {
            pool[cell2[0]].selected = false
        }
        if(cell2.count == 2) {
            matrix[cell2[0]][cell2[1]].selected = false
        }
        
        //HANDLE THE DIFFERENT SWAP CASES
        if(cell1.count == 1 && cell2.count == 1) {
            let index1 = cell1
            let letter1 = pool[cell1[0]].letter
            
            let index2 = cell2
            let letter2 = pool[cell2[0]].letter
            
            pool[index1[0]].letter = letter2
            pool[index2[0]].letter = letter1
        }
        
        if(cell1.count == 1 && cell2.count == 2) {
            let index1 = cell1
            let letter1 = pool[cell1[0]].letter
            
            let index2 = cell2
            let letter2 = matrix[cell2[0]][cell2[1]].letter
            
            pool[index1[0]].letter = letter2
            matrix[index2[0]][index2[1]].letter = letter1
        }
        
        if(cell1.count == 2 && cell2.count == 1) {
            let index1 = cell1
            let letter1 = matrix[cell1[0]][cell1[1]].letter
            
            let index2 = cell2
            let letter2 = pool[cell2[0]].letter
            
            matrix[index1[0]][index1[1]].letter = letter2
            pool[index2[0]].letter = letter1
        }
        
        if(cell1.count == 2 && cell2.count == 2) {
            let index1 = cell1
            let letter1 = matrix[cell1[0]][cell1[1]].letter
            
            let index2 = cell2
            let letter2 = matrix[cell2[0]][cell2[1]].letter
            
            matrix[index1[0]][index1[1]].letter = letter2
            matrix[index2[0]][index2[1]].letter = letter1
        }
        
        //CHECK IF WE WON
        let win = checkForWin()
        
        if(win) {
            gameWon = true
        }
        
        print(win ? "/~~~WIN~~~/" : "/~~~NO WIN~~~/")
    }
    
    //TRY TO REPLACE TILE
    func replaceCell() {
        //DECREASE SWAP COUNT
        replacesLeft -= 1
        
        //SWAP IN POOL
        if(selectedCellIndex!.count == 1) {
            pool[selectedCellIndex![0]].selected = false
            pool[selectedCellIndex![0]].letter = ViewModel.getRandomLetter()
        }
        
        //SWAP IN MATRIX
        if(selectedCellIndex!.count == 2) {
            matrix[selectedCellIndex![0]][selectedCellIndex![1]].selected = false
            matrix[selectedCellIndex![0]][selectedCellIndex![1]].letter = ViewModel.getRandomLetter()
            
        }
        selectedCellIndex = nil
        
        //ADD ADDITIONAL TILE TO POOL
        var placed = false
        for cell in pool {
            if(cell.letter == "" && !placed) {
                placed = true
                let ind = getPoolCellIndex(id: cell.id)
                pool[ind].letter = ViewModel.getRandomLetter()
            }
        }
    }
    
    //RESET THE MATRIX LETTERS TO THE POOL
    func resetGame() {
        var letters = [String]()
        
        //GET ALL LETTERS FROM MATRIX
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                if(matrix[i][j].letter != "") {
                    letters.append(matrix[i][j].letter)
                    matrix[i][j].letter = ""
                    matrix[i][j].selected = false
                }
            }
        }
        
        //PLACE LETTERS IN POOL
        for i in 0..<letters.count {
            var placed = false
            
            for j in 0..<pool.count {
                if(pool[j].letter == "" && placed == false) {
                    pool[j].letter = letters[i]
                    pool[j].selected = false
                    placed = true
                }
            }
        }
        
        //CLOSE SETTINGS VIEW
        showingSettings = false
    }
    
    //CLEAR THE GAME AND GET NEW LETTERS
    func newGame() {
        //RESET SWAP COUNT
        replacesLeft = 3
        
        //CLEAR MATRIX
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                matrix[i][j].letter = ""
                matrix[i][j].selected = false
            }
        }
        
        //CLEAR POOL
        for i in 0..<pool.count {
            pool[i].letter = ""
            pool[i].selected = false
        }
        
        //FILL POOL
        for i in 0..<numberOfLetters {
            pool[i].letter = ViewModel.getRandomLetter()
        }
        
        //CLOSE SETTINGS VIEW
        showingSettings = false
    }
    
    //CHECK THE GAME TO SEE IF WE WON
    func checkForWin() -> Bool {
        //RESET MATRIX VALID FLAGS
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                matrix[i][j].inValidWord = false
            }
        }
        
//        VALIDATE LETTER ON MATRIX IN WORDS HORIZONTALLY
        for i in 0..<matrix[0].count {
            var row: [String] = []
            for j in 0..<matrix[0].count {
                if(matrix[i][j].letter == "") {
                    row.append("")
                } else {
                    row.append(matrix[i][j].letter)
                }

            }

            //CHECK ROW FOR WORDS
            checkRowForWords(index: i, row: row)
        }

        //VALIDATE LETTER ON MATRIX IN WORDS VERTICALLY
        for i in 0..<matrix[0].count {
            var col: [String] = []
            for j in 0..<matrix[0].count {
                if(matrix[j][i].letter == "") {
                    col.append("")
                } else {
                    col.append(matrix[j][i].letter)
                }
                
            }
            
            //CHECK ROW FOR WORDS
            checkColumnForWords(index: i, col: col)
        }
        
        
        //CHECK IF ALL LETTERS IN ARE VALID
        var allLettersValid = true
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                if(matrix[i][j].letter != "" && matrix[i][j].inValidWord == false) {
                    allLettersValid = false
                }
            }
        }
        
        //CHECK IF POOL IS EMPTY
        var poolIsEmpty = true
        for i in 0..<pool.count {
            if(pool[i].letter != "") {
                poolIsEmpty = false
            }
        }
        
        //CHECK IF ALL LETTERS CONNECT
        var rowFill = [false, false, false, false, false, false, false, false]
        var colFill = [false, false, false, false, false, false, false, false]
        for i in 0..<matrix[0].count {
            for j in 0..<matrix[0].count {
                if(matrix[i][j].letter != "") {
                    rowFill[i] = true
                    colFill[i] = true
                }
            }
        }
        
        var lettersFullyConnected = true
        //CHECK ROWS
        var start = false
        var end = false
        for i in 0..<matrix[0].count {
            if(end && rowFill[i]) { lettersFullyConnected = false }
            if(start && !rowFill[i]) { end = true }
            if(rowFill[i]) { start = true }
        }
        
        //CHECK COLS
        start = false
        end = false
        for i in 0..<matrix[0].count {
            if(end && colFill[i]) { lettersFullyConnected = false }
            if(start && !colFill[i]) { end = true }
            if(colFill[i]) { start = true }
        }
        
        print("CONNECTED: \(lettersFullyConnected)")
        //RETURN IF USER WON
        return (allLettersValid && poolIsEmpty && lettersFullyConnected)
    }
    
    //CHECK A ROW FOR WORDS
    func checkRowForWords(index: Int, row: [String]) {
        var newWord = ""
        var newWordIndex: [Int] = []
        var i = -1
        
        //MAIN LOOP
        for letter in row {
            i += 1
            
            if(letter == "") {
                //CHECK NEW WORD
                if(isValidWord(word: newWord.lowercased())) {
                    for ind in newWordIndex {
                        matrix[index][ind].inValidWord = true
                    }
                }
                
                //RESET VARS
                newWord = ""
                newWordIndex = []
            } else {
                //ADD LETTER TO WORD
                newWord.append(letter)
                newWordIndex.append(i)
            }
        }
        
        //CHECK LAST WORD
        if(isValidWord(word: newWord.lowercased())) {
            for ind in newWordIndex {
                matrix[index][ind].inValidWord = true
            }
        }
    }
    
    //CHECK A COLUMN FOR WORDS
    func checkColumnForWords(index: Int, col: [String]) {
        var newWord = ""
        var newWordIndex: [Int] = []
        var i = -1
        
        //MAIN LOOP
        for letter in col {
            i += 1
            
            if(letter == "") {
                //CHECK NEW WORD
                if(isValidWord(word: newWord.lowercased())) {
                    for ind in newWordIndex {
                        matrix[ind][index].inValidWord = true
                    }
                }
                
                //RESET VARS
                newWord = ""
                newWordIndex = []
            } else {
                //ADD LETTER TO WORD
                newWord.append(letter)
                newWordIndex.append(i)
            }
        }
        
        //CHECK LAST WORD
        if(isValidWord(word: newWord.lowercased())) {
            for ind in newWordIndex {
                matrix[ind][index].inValidWord = true
            }
        }
    }
    
    //CHECK IF A WORD IS VALID
    func isValidWord(word: String) -> Bool {
        //print("WORD: (\(word))")
        
        //DONT ALLOW 1 LETTER WORDS
        if(word.count == 1) {
            return false
        }
        
        //LIST OF VALID 2 LETTER WORDS
        if(word.count == 2) {
            if(word == "ab") {return true}
            if(word == "ad") {return true}
            if(word == "am") {return true}
            if(word == "an") {return true}
            if(word == "as") {return true}
            if(word == "at") {return true}
            if(word == "be") {return true}
            if(word == "by") {return true}
            if(word == "do") {return true}
            if(word == "ex") {return true}
            if(word == "go") {return true}
            if(word == "he") {return true}
            if(word == "hi") {return true}
            if(word == "if") {return true}
            if(word == "in") {return true}
            if(word == "is") {return true}
            if(word == "it") {return true}
            if(word == "me") {return true}
            if(word == "my") {return true}
            if(word == "no") {return true}
            if(word == "of") {return true}
            if(word == "oh") {return true}
            if(word == "oi") {return true}
            if(word == "ok") {return true}
            if(word == "on") {return true}
            if(word == "or") {return true}
            if(word == "ox") {return true}
            if(word == "pi") {return true}
            if(word == "so") {return true}
            if(word == "to") {return true}
            if(word == "up") {return true}
            if(word == "us") {return true}
            if(word == "we") {return true}
            if(word == "yo") {return true}
            return false
        }
        
        if(word == "") {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

struct matrixCell: Identifiable {
    //VARIABLES
    var letter: String
    var id: UUID = UUID()
    var selected: Bool = false
    var inValidWord = false
}
