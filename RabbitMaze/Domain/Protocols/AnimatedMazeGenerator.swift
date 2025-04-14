//
//  AnimatedMazeGenerator.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 13/04/25.
//

protocol AnimatedMazeGenerator {
    func generateSteps(width: Int, height: Int) -> AsyncStream<MazeStep>
}
