//
//  AnimatedMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

protocol AnimatedMazeGenerator {
    var grid: [[CellType]] { get set }
    var width: Int { get }
    var height: Int { get }
    func generateSteps() -> AsyncStream<MazeStep>
}
