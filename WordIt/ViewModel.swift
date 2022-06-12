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
    
    
    //RETUNR RANDOM LETTER TO CREATE NEW CELL
    static func getRandomLetter() -> String {
        //Create array of all letters in actual game and return a random value
//        let rand = Int.random(in: 0..<10)
        
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<1).map{ _ in letters.randomElement()! })
    }
    
    //INITIALIZE
    init(matrixSize: Int, poolSize: Int, numOfLetters: Int) {

        matrix = [[]]
        pool = []

//        matrix = Array(repeating: Array(repeating: matrixCell(letter: "", id: UUID()), count: matrixSize), count: matrixSize)

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
    
    //MATRIX CELL TAPPED
    func tapMatrixCell(cell: matrixCell) {
        //PLAY SOUND
        AudioServicesPlaySystemSound(SystemSoundID(1105))
        
        //SEE IF FIRST CELL TAPPED
//        if (selectedCell == nil) {
//            selectedCell = cell
//        } else {
            //SWAP CELLS
//            let index1 = getPoolCellIndex(id: cell.id)
//            let letter1 = cell.letter
//            let index2 = getPoolCellIndex(id: selectedCell!.id)
//            let letter2 = selectedCell!.letter
//
//            pool[index1].letter = letter2
//            pool[index2].letter = letter1
//
            //RESET SELECTION
//            selectedCell = nil
//        }
    }
     
    //POOL CELL TAPPED
    func tapCell(cellIndex: [Int]) {
        //PLAY SOUND
        AudioServicesPlaySystemSound(SystemSoundID(1105))
        
        //SEE IF FIRST CELL TAPPED
        if (selectedCellIndex == nil) {
            selectedCellIndex = cellIndex
        } else {
            //SWAP CELLS
            swapCells(cell1: cellIndex, cell2: selectedCellIndex!)
            
            //RESET SELECTION
            selectedCellIndex = nil
        }
    }
    
    //SWAP CELLS
    func swapCells(cell1: [Int], cell2: [Int]) {
        if(cell1.count == 1 && cell2.count == 1) {
            let index1 = cell1
            let letter1 = pool[cell1[0]].letter
            
            let index2 = cell2
            let letter2 = pool[cell2[0]].letter
            
            pool[index1[0]].letter = letter2
            pool[index2[0]].letter = letter1
        }
        
    }

}

struct matrixCell: Identifiable {
    
    //VARIABLES
    var letter: String
    var id: UUID = UUID()

}
