import SwiftUI

struct JoystickView: View {
    let moveUp: () -> Void = {}
    let moveDown: () -> Void = {}
    let moveLeft: () -> Void = {}
    let moveRight: () -> Void = {}
    var disabled: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 8) {
                Button(action: moveUp, label: {
                    Text("⬆️")
                })
                .disabled(disabled)
            }
            HStack() {
                Button(action: moveLeft, label: {
                    Text("⬅️")
                })
                .disabled(disabled)
                Spacer()
                Button(action: moveRight, label: {
                    Text("➡️")
                })
                .disabled(disabled)
            }
            HStack(spacing: 0) {
                Button(action: moveDown, label: {
                    Text("⬇️")
                })
                .disabled(disabled)
            }
        }
        .font(.system(size: 30))
        .frame(maxWidth: 100)
    }
}

#Preview {
    JoystickView()
}
