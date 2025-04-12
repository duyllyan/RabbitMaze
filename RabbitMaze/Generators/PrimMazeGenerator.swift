class PrimMazeGenerator: MazeGenerator {
    struct Position: Equatable, Hashable {
        let row: Int
        let column: Int
    }
    
    func generate(maze: Maze) {
        var visited = Set<Position>()
        var walls = [Position]()
        
        let start = Position(row: 1, column: 1)
        visited.insert(start)
        maze.setCell(row: 1, column: 1, to: .path)
        maze.setCell(row: 0, column: 1, to: .path)
        
        func neighbors(of position: Position) -> [Position] {
            let directions = [
                (-2, 0), (2, 0), (0, -2), (0, 2)
            ]
            return directions.compactMap { dr, dc in
                let newRow = position.row + dr
                let newCol = position.column + dc
                if newRow > 0 && newRow < maze.rows - 1 &&
                    newCol > 0 && newCol < maze.columns - 1 {
                    return Position(row: newRow, column: newCol)
                }
                return nil
            }
        }
        
        walls.append(contentsOf: neighbors(of: start))
        
        while !walls.isEmpty {
            let wall = walls.remove(at: Int.random(in: 0..<walls.count))
            let adjacent = neighbors(of: wall).filter { visited.contains($0) }
            
            if adjacent.count == 1 {
                maze.setCell(row: wall.row, column: wall.column, to: .path)
                
                let from = adjacent[0]
                let between = Position(
                    row: (wall.row + from.row) / 2,
                    column: (wall.column + from.column) / 2
                )
                maze.setCell(row: between.row, column: between.column, to: .path)
                
                visited.insert(wall)
                walls.append(contentsOf: neighbors(of: wall).filter { !visited.contains($0) })
            }
        }
        
        for col in stride(from: 1, to: maze.columns - 1, by: 2) {
            if maze.getCell(row: maze.rows - 2, column: col) == .path {
                maze.setCell(row: maze.rows - 1, column: col, to: .path)
                break
            }
        }
    }
}
