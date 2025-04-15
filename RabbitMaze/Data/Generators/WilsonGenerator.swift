final class WilsonGenerator: AnimatedMazeGenerator {

    var grid: [[CellType]]
    var width: Int
    var height: Int

    init(width: Int, height: Int) {
        self.width = width.toOdd
        self.height = height.toOdd
        self.grid = GridUtility.initMaze(width: width, height: height)
    }

    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                var unvisited: Set<Coordinate> = []
                for row in stride(from: 1, to: self.height, by: 2) {
                    for col in stride(from: 1, to: self.width, by: 2) {
                        unvisited.insert(Coordinate(row: row, col: col))
                    }
                }

                guard let initialMazeCell = unvisited.randomElement() else {
                    continuation.finish()
                    return
                }
                unvisited.remove(initialMazeCell)

                initialMazeCell.updateCell(in: &grid, continuation: continuation, type: .path)

                while !unvisited.isEmpty {
                    let startCell = unvisited.randomElement()!

                    var walkPath: [Coordinate : Coordinate] = [:]
                    var currentWalkPos = startCell

                    while self.grid[currentWalkPos.row][currentWalkPos.col] == .wall {
                        let potentialNeighbors = currentWalkPos.findNeighbors(in: self.grid)
                        guard !potentialNeighbors.isEmpty else { break }
                        let nextWalkPos = potentialNeighbors.randomElement()!

                        walkPath[currentWalkPos] = nextWalkPos

                        currentWalkPos = nextWalkPos
                    }

                    if startCell != currentWalkPos {
                        var carvePos = startCell
                        while carvePos != currentWalkPos {
                            carvePos.updateCell(in: &grid, continuation: continuation, type: .path)

                            unvisited.remove(carvePos)

                            guard let nextPos = walkPath[carvePos] else { break }

                            let wall = Coordinate(row: (carvePos.row + nextPos.row) / 2, col: (carvePos.col + nextPos.col) / 2)

                            wall.updateCell(in: &grid, continuation: continuation, type: .path)

                            try? await Task.sleep(nanoseconds: Constants.animationStepDelay)

                            carvePos = nextPos
                        }
                    } else if let firstStep = walkPath[startCell], firstStep == currentWalkPos {
                        startCell.updateCell(in: &grid, continuation: continuation, type: .path)
                        unvisited.remove(startCell)

                        let wall = Coordinate(row: (startCell.row + currentWalkPos.row) / 2, col: (startCell.col + currentWalkPos.col) / 2)
                        wall.updateCell(in: &grid, continuation: continuation, type: .path)

                        try? await Task.sleep(nanoseconds: Constants.animationStepDelay / 2)
                    } else {
                         if unvisited.contains(startCell) {
                             unvisited.remove(startCell)
                         }
                    }
                }

                continuation.finish()
            }
        }
    }
}
