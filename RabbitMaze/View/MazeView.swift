//
//  MazeView.swift
//  RabbitMaze
//
//  Created by Duyllyan Almeida de Carvalho on 12/04/25.
//

import SwiftUI

struct MazeView: View {
    @ObservedObject private var viewModel = MazeViewModel(generator: RecursiveDivisionGenerator(width: 29, height: 31))
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.maze.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.maze[row].count, id: \.self) { col in
                        let cell = viewModel.maze[row][col]
                        let position = Coordinate(row: row, col: col)

                        Rectangle()
                            .fill(colorForCell(cell, at: position))
                            .frame(width: 9, height: 9)
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
