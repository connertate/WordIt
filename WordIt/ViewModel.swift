//
//  ViewModel.swift
//  WordIt
//
//  Created by Conner Tate on 5/14/22.
//

import Foundation
import SwiftUI

final class ViewModel: ObservableObject{

    //VARIABLES
    @Published var matrix: [[matrixCell]]
    @Published var pool: [matrixCell]
    @Published var selectedCell: matrixCell?
    
    
    //RETUNR RANDOM LETTER TO CREATE NEW CELL
    static func getRandomLetter() -> String {
        //Create array of all letters in actual game and return a random value
        let rand = Int.random(in: 0..<10)
        if(rand < 1) {
            return "A"
        }
        if(rand < 2) {
            return "B"
        }
        if(rand < 3) {
            return "C"
        }
        if(rand < 4) {
            return "D"
        }
        if(rand < 5) {
            return "E"
        }
        if(rand < 6) {
            return "F"
        }
        if(rand < 7) {
            return "G"
        }
        if(rand < 8) {
            return "H"
        }
        if(rand < 9) {
            return "I"
        }
        return "J"
    }
    
    //INITIALIZE
    init(matrixSize: Int, poolSize: Int, numOfLetters: Int) {

        //INIT MATRIX
        matrix = Array(repeating: Array(repeating: matrixCell(letter: "", id: UUID()), count: matrixSize), count: matrixSize)
        
        //INIT POOL
        pool = []
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
    
    //WHEN POOL CELL IS TAPPED
    func tapPoolCell(cell: matrixCell) {
        
        //SEE IF FIRST CELL TAPPED
        if (selectedCell == nil) {
            selectedCell = cell
        } else {
            //SWAP CELLS
            let index1 = getPoolCellIndex(id: cell.id)
            let letter1 = cell.letter
            let index2 = getPoolCellIndex(id: selectedCell!.id)
            let letter2 = selectedCell!.letter
            
            pool[index1].letter = letter2
            pool[index2].letter = letter1
            
            //RESET SELECTION
            selectedCell = nil
        }
    }

}

struct matrixCell: Identifiable {
    
    //VARIABLES
    var letter: String
    var id: UUID = UUID()

}
