//
//  BinaryTreeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

final class BinaryTreeGenerator: AnimatedMazeGenerator {
    var height: Int
    var width: Int
    var grid: [[CellType]] = []
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = GridUtility.initMazeWithOddIntersections(width: self.width, height: self.height)
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                for row in stride(from: 1, to: grid.count, by: 2) {
                    for col in stride(from: 1, to: grid[0].count, by: 2) {
                        let current = Coordinate(row: row, col: col)
                        current.updateCell(in: &grid, continuation: continuation)
                        let directions = [Direction.down, Direction.right]
                        if let neighbor = current.findNeighbors(in: grid, at: directions).randomElement() {
                            let intermediate = Coordinate(row: (current.row + neighbor.row) / 2, col: (current.col + neighbor.col) / 2)
                            intermediate.updateCell(in: &grid, continuation: continuation)
                            try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                        }
                    }
                }
                
                continuation.finish()
            }
        }
    }
}
