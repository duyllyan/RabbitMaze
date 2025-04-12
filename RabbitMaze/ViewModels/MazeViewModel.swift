//
//  MazeViewModel.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import Foundation

class MazeViewModel: ObservableObject {
    @Published private(set) var maze: Maze
    
    private let rows: Int
    private let columns: Int
    private let generator: MazeGenerator
    
    init(rows: Int = 21, columns: Int = 21, generator: MazeGenerator = HuntAndKillMazeGenerator()) {
        self.rows = rows
        self.columns = columns
        self.generator = generator
        self.maze = Maze(rows: rows, columns: columns)
        generateNewMaze()
    }
    
    func generateNewMaze() {
        maze = Maze(rows: rows, columns: columns)
        generator.generate(maze: maze)
    }
    
    func cellAt(row: Int, column: Int) -> MazeCell? {
            return maze.getCell(row: row, column: column)
    }

    var grid: [[MazeCell]] {
        return maze.grid
    }
}
