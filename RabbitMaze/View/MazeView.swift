//
//  MazeView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct MazeView: View {
    @ObservedObject private var viewModel = MazeViewModel(generator: BinaryTreeGenerator(), width: 31, height: 31)
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.maze.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.maze[row].count, id: \.self) { col in
                        let cell = viewModel.maze[row][col]
                        let position = Coordinate(row: row, col: col)

                        Rectangle()
                            .fill(colorForCell(cell, at: position))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .onAppear {
            viewModel.start()
        }
    }

    func colorForCell(_ cell: CellType, at position: Coordinate) -> Color {
        if position == viewModel.entry {
            return .blue
        } else if position == viewModel.exit {
            return .red
        } else {
            return cell == .wall ? .green : .yellow
        }
    }
}

#Preview {
    MazeView()
}
