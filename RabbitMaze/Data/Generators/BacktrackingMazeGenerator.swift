//
//  BacktrackingMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

final class BacktrackingMazeGenerator: AnimatedMazeGenerator {
    var height: Int
    var width: Int
    var grid: [[CellType]] = []
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = GridUtility.initMaze(width: width, height: height)
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                let start = GridUtility.startCell(grid)
                start.updateCell(in: &grid, continuation: continuation)
                
                var stack: [Coordinate] = [start]
                
                while !stack.isEmpty {
                    let current = stack.last!
                    let neighbors = current.findNeighbors(in: grid, type: .wall)
                    
                    if let next = neighbors.randomElement() {
                        let wall = Coordinate(row: (current.row + next.row) / 2, col: (current.col + next.col) / 2)
                        wall.updateCell(in: &grid, continuation: continuation)
                        next.updateCell(in: &grid, continuation: continuation)
                        stack.append(next)
                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                    } else {
                        stack.removeLast()
                    }
                }
                
                continuation.finish()
            }
        }
    }
}
