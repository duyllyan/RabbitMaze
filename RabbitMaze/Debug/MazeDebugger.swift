//
//  MazeDebugger.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import Foundation

class MazeDebugger {
    static func printMaze(_ maze: Maze, highlight: (row: Int, col: Int)? = nil) {
        for row in 0..<maze.rows {
            var line = ""
            for col in 0..<maze.columns {
                if let highlight = highlight, highlight.row == row, highlight.col == col {
                    line += "🔴" // célula sendo visitada
                } else {
                    switch maze.getCell(row: row, column: col) {
                    case .wall: line += "🟩"
                    case .path: line += "🟨"
                    case nil: line += "  "
                    }
                }
            }
            print(line)
        }
        print("⏸⏸⏸⏸⏸⏸⏸⏸⏸⏸")
    }
}
