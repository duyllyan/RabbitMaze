//
//  RandomizePrimsGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 14/04/25.
//

final class RandomizePrimsGenerator: AnimatedMazeGenerator {
    func generateSteps(width: Int, height: Int) -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                var grid = GridUtility.initMaze(width: width, height: height)
                
                let start = GridUtility.startCell(grid)
                start.updateCell(in: &grid, continuation: continuation)
                
                var openCells: Set<Coordinate> = []
                openCells.insert(start)
                
                while !openCells.isEmpty {
                    if let random = openCells.randomElement() {
                        if let neighbor = random.findNeighbors(in: grid, type: .wall).randomElement() {
                            let intermediate = Coordinate(row: (random.row + neighbor.row) / 2, col: (random.col + neighbor.col) / 2)
                            intermediate.updateCell(in: &grid, continuation: continuation)
                            neighbor.updateCell(in: &grid, continuation: continuation)
                            try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                            openCells.insert(neighbor)
                        } else {
                            openCells.remove(random)
                        }
                    }
                }
                
                continuation.finish()
            }
        }
    }
}
