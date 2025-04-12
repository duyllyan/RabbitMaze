//
//  HuntAndKillMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

class HuntAndKillMazeGenerator: MazeGenerator {
    struct Position: Equatable, Hashable {
        let row: Int
        let column: Int
    }

    func generate(maze: Maze) {
        var visited = Set<Position>()
        var current: Position? = Position(row: 1, column: 1)

        func unvisitedNeighbors(of pos: Position) -> [(neighbor: Position, between: Position)] {
            let directions = [(-2, 0), (2, 0), (0, -2), (0, 2)]
            return directions.compactMap { dr, dc in
                let newRow = pos.row + dr
                let newCol = pos.column + dc
                let neighbor = Position(row: newRow, column: newCol)
                let between = Position(row: pos.row + dr / 2, column: pos.column + dc / 2)
                guard maze.getCell(row: newRow, column: newCol) != nil,
                      !visited.contains(neighbor) else { return nil }
                return (neighbor, between)
            }
        }

        func neighborVisited(of pos: Position) -> (neighbor: Position, between: Position)? {
            let directions = [(-2, 0), (2, 0), (0, -2), (0, 2)]
            return directions.compactMap { dr, dc in
                let newRow = pos.row + dr
                let newCol = pos.column + dc
                let neighbor = Position(row: newRow, column: newCol)
                let between = Position(row: pos.row + dr / 2, column: pos.column + dc / 2)
                guard maze.getCell(row: newRow, column: newCol) != nil,
                      visited.contains(neighbor) else { return nil }
                return (neighbor, between)
            }.randomElement()
        }

        while let pos = current {
            visited.insert(pos)
            maze.setCell(row: pos.row, column: pos.column, to: .path)

            let neighbors = unvisitedNeighbors(of: pos)
            if let (next, between) = neighbors.randomElement() {
                maze.setCell(row: between.row, column: between.column, to: .path)
                current = next
            } else {
                // HUNT phase
                current = nil
                for row in stride(from: 1, to: maze.rows - 1, by: 2) {
                    for col in stride(from: 1, to: maze.columns - 1, by: 2) {
                        let candidate = Position(row: row, column: col)
                        if !visited.contains(candidate),
                           let (neighbor, between) = neighborVisited(of: candidate) {
                            maze.setCell(row: between.row, column: between.column, to: .path)
                            maze.setCell(row: candidate.row, column: candidate.column, to: .path)
                            visited.insert(candidate)
                            current = candidate
                            break
                        }
                    }
                    if current != nil { break }
                }
            }
        }

        // entrada
        maze.setCell(row: 0, column: 1, to: .path)
        // saída
        for col in stride(from: 1, to: maze.columns - 1, by: 2) {
            if maze.getCell(row: maze.rows - 2, column: col) == .path {
                maze.setCell(row: maze.rows - 1, column: col, to: .path)
                break
            }
        }
    }
}
