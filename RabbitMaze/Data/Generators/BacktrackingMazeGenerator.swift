//
//  BacktrackingMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

final class BacktrackingMazeGenerator: AnimatedMazeGenerator {
    
    func generateSteps(width: Int, height: Int) -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                let adjustedWidth = width.toOdd
                let adjustedHeight = height.toOdd
                var grid = Array(repeating: Array(repeating: CellType.wall, count: adjustedWidth), count: adjustedHeight)
                
                let start = GridUtility.randomOddCoordinate(width: adjustedWidth, height: adjustedHeight)
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
