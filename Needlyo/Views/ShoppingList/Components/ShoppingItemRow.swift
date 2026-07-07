import SwiftUI

struct ShoppingItemRow: View {

    let item: ShoppingItem
    let onToggleCompletion: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggleCompletion) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            item.isCompleted ? Color.accentColor : Color.secondary,
                            lineWidth: 1.5
                        )
                        .background(
                            Circle()
                                .fill(item.isCompleted ? Color.accentColor : Color.clear)
                        )
                        .frame(width: 24, height: 24)

                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.body)
                .foregroundStyle(.primary.opacity(item.isCompleted ? 0.35 : 1))
                .strikethrough(item.isCompleted)

            Spacer()
        }
        .frame(minHeight: 48)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: item.isCompleted)
    }

}

#Preview {
    List {
        ShoppingItemRow(
            item: ShoppingItem(title: "Milk"),
            onToggleCompletion: {}
        )

        ShoppingItemRow(
            item: ShoppingItem(title: "Bread", isCompleted: true),
            onToggleCompletion: {}
        )
    }
}
