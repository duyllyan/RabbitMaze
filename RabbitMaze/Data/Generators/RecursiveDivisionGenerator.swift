//
//  RecursiveDivisionGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 15/04/25.
//

final class RecursiveDivisionGenerator: AnimatedMazeGenerator {
    var grid: [[CellType]]
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        self.width = width.toOdd
        self.height = height.toOdd
        self.grid = GridUtility.initMaze(width: self.width, height: self.height, type: .path)
        
        let rows = grid.count
        let columns = grid[0].count
        
        for col in 0..<columns {
            grid[0][col] = .wall
            grid[rows - 1][col] = .wall
        }
        
        for row in 0..<rows {
            grid[row][0] = .wall
            grid[row][columns - 1] = .wall
        }
    }
    
    func generateSteps() -> AsyncStream<MazeStep> {
        AsyncStream { continuation in
            Task {
                await recursiveDivision(grid: &grid, minRow: 1, maxRow: grid.count - 2, minCol: 1, maxCol: grid[0].count - 2, continuation: continuation)
                
                continuation.finish()
            }
        }
    }
    
    private func recursiveDivision(
        grid: inout [[CellType]],
        minRow: Int,
        maxRow: Int,
        minCol: Int,
        maxCol: Int,
        continuation: AsyncStream<MazeStep>.Continuation
    ) async {
        
        guard maxRow - minRow >= 2, maxCol - minCol >= 2 else { return }
        
        let width = maxCol - minCol
        let height = maxRow - minRow
        
        let orientation = Orientation.chooseOrientation(width: width, height: height)
        
        switch orientation {
        case .horizontal:
            let firstPossibleRow = minRow.isEven ? minRow + 2 : minRow + 1
            let lastPossibleRow = maxRow.isEven ? maxRow - 2 : maxRow - 1
            
            let possibleHorizontalWalls = Array(stride(from: firstPossibleRow, through: lastPossibleRow, by: 2))
            guard firstPossibleRow <= lastPossibleRow, let horizontalWall = possibleHorizontalWalls.randomElement() else { return }
            
            let firstPossibleColumn = minCol.isEven ? minCol + 1 : minCol
            let lastPossibleColumn = maxCol.isEven ? maxCol - 1 : maxCol
            
            let possiblePassages = Array(stride(from: firstPossibleColumn, through: lastPossibleColumn, by: 2))
            guard firstPossibleColumn <= lastPossibleColumn, let passageCol = possiblePassages.randomElement() else { return }
            
            for col in minCol...maxCol {
                if col != passageCol {
                    let wall = Coordinate(row: horizontalWall, col: col)
                    wall.updateCell(in: &grid, continuation: continuation, type: .wall)
                    try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                }
            }
            
            await recursiveDivision(grid: &grid, minRow: minRow, maxRow: horizontalWall - 1, minCol: minCol, maxCol: maxCol, continuation: continuation)
            
            await recursiveDivision(grid: &grid, minRow: horizontalWall + 1, maxRow: maxRow, minCol: minCol, maxCol: maxCol, continuation: continuation)
            
        case .vertical:
            let firstPossibleCol = minCol.isEven ? minCol + 2 : minCol + 1
            let lastPossibleCol = maxCol.isEven ? maxCol - 2 : maxCol - 1
            let possibleVerticalWalls = Array(stride(from: firstPossibleCol, through: lastPossibleCol, by: 2))
            guard firstPossibleCol <= lastPossibleCol, let verticalWall = possibleVerticalWalls.randomElement() else { return }
            
            let firstPossibleRow = minRow.isEven ? minRow + 1 : minRow
            let lastPossibleRow = maxRow.isEven ? maxRow - 1 : maxRow
            
            let possiblePassages = Array(stride(from: firstPossibleRow, through: lastPossibleRow, by: 2))
            guard firstPossibleRow <= lastPossibleRow, let passageRow = possiblePassages.randomElement() else { return }
            
            for row in minRow...maxRow {
                if row != passageRow {
                    let wall = Coordinate(row: row, col: verticalWall)
                    wall.updateCell(in: &grid, continuation: continuation, type: .wall)
                    try? await Task.sleep(nanoseconds: Constants.animationStepDelay)
                }
            }
            
            await recursiveDivision(grid: &grid, minRow: minRow, maxRow: maxRow, minCol: verticalWall + 1, maxCol: maxCol, continuation: continuation)
            
            await recursiveDivision(grid: &grid, minRow: minRow, maxRow: maxRow, minCol: minCol, maxCol: verticalWall - 1, continuation: continuation)
        }
    }
}

private enum Orientation {
    case horizontal
    case vertical
    
    static func chooseOrientation(width: Int, height: Int) -> Orientation {
        if width > height {
            .vertical
        } else if width < height {
            .horizontal
        } else {
            Bool.random() ? .horizontal : .vertical
        }
    }
}
