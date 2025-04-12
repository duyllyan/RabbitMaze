//
//  RecursiveBacktrackerMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//
import Foundation

class RecursiveBacktrackerMazeGenerator: MazeGenerator {
    private struct Position: Equatable {
        let row: Int
        let column: Int
    }
    
    private let directions = [
        (dr: -2, dc: 0), //up
        (dr: 2, dc: 0),  //down
        (dr: 0, dc: -2), //left
        (dr: 0, dc: 2),  //rigth
    ]
    
    func generate(maze: Maze) {
        var visited = Array(
            repeating: Array(repeating: false, count: maze.columns), count: maze.rows
        )
        
        let possibleStarts = stride(from: 1, to: maze.columns - 1, by: 2).map { $0 }
        guard let startColumn = possibleStarts.randomElement() else { return }
        let start = Position(row: 1, column: startColumn)
        maze.setCell(row: 0, column: startColumn, to: .path)
        
        func dfs(from position: Position) {
            visited[position.row][position.column] = true
            maze.setCell(row: position.row, column: position.column, to: .path)
            MazeDebugger.printMaze(maze, highlight: (row: position.row, col: position.column))
            
            for dir in directions.shuffled() {
                let newRow = position.row + dir.dr
                let newCol = position.column + dir.dc
                
                if newRow > 0, newRow < maze.rows - 1, newCol > 0, newCol < maze.columns - 1, !visited[newRow][newCol] {
                    let wallRow = position.row + dir.dr / 2
                    let wallCol = position.column + dir.dc / 2
                    maze.setCell(row: wallRow, column: wallCol, to: .path)
                    
                    dfs(from: Position(row: newRow, column: newCol))
                }
            }
        }
        
        dfs(from: start)
        
        for col in stride(from: 1, to: maze.columns - 1, by: 2) {
            if maze.getCell(row: maze.rows - 2, column: col) == .path {
                maze.setCell(row: maze.rows - 1, column: col, to: .path)
                break
            }
        }
    }
}
