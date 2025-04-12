//
//  Maze.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

class Maze {
    private(set) var grid: [[MazeCell]]
    
    let rows: Int
    let columns: Int
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: .wall, count: columns), count: rows)
    }
    
    func setCell(row: Int, column: Int, to cell: MazeCell) {
        guard isValid(row: row, column: column) else { return }
        grid[row][column] = cell
    }
    
    func getCell(row: Int, column: Int) -> MazeCell? {
        guard isValid(row: row, column: column) else { return nil }
        return grid[row][column]
    }
    
    private func isValid(row: Int, column: Int) -> Bool {
        row >= 0 && row < rows && column > 0 && column < columns
    }
}
