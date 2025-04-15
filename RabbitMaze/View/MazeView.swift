//
//  MazeView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct MazeView: View {
    @ObservedObject private var viewModel = MazeViewModel(generator: AldousBorderGenerator(width: 7, height: 7))
    @State private var wonGame = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.maze.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.maze[row].count, id: \.self) { col in
                        let cell = viewModel.maze[row][col]
                        let position = Coordinate(row: row, col: col)

                        Text(fillCell(cell, at: position))
                    }
                }
            }
            
            JoystickView(
                moveUp: {
                    viewModel.move(direction: .up)
                },
                moveDown: {
                    viewModel.move(direction: .down)
                },
                moveLeft: {
                    viewModel.move(direction: .left)
                },
                moveRight: {
                    viewModel.move(direction: .right)
                },
                disabled: viewModel.isGenerating
            )
        }
        .onAppear {
            viewModel.start()
        }
        .alert("Congrats! You won!", isPresented: $viewModel.wonGame) {
               Button("OK") {
                   viewModel.restart()
               }
             }
    }

    func fillCell(_ cell: CellType, at position: Coordinate) -> String {
        if position == viewModel.entry {
            return "🐰"
        } else if position == viewModel.exit {
            return "🥕"
        } else {
            return cell == .wall ? "🟩" : "🟧"
        }
    }
}

#Preview {
    MazeView()
}
