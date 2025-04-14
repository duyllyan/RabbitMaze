//
//  Direction.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

enum Direction: CaseIterable {
    case up
    case down
    case left
    case right

    var delta: (row: Int, col: Int) {
        switch self {
        case .up: return (-2, 0)
        case .down: return (2, 0)
        case .left: return (0, -2)
        case .right: return (0, 2)
        }
    }
}
