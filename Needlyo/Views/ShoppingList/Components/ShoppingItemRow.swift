import SwiftUI

struct ShoppingItemRow: View {

    let item: ShoppingItem
    let onToggleCompletion: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onToggleCompletion) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            item.isCompleted ? Color.appPrimary : Color.appBorder,
                            lineWidth: 1.5
                        )
                        .background(
                            Circle()
                                .fill(item.isCompleted ? Color.appPrimarySoft : Color.appSurface)
                        )
                        .frame(width: 20, height: 20)

                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.appPrimaryStrong)
                    }
                }
                .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.subheadline)
                .foregroundStyle(item.isCompleted ? Color.appTextSecondary : Color.appTextPrimary)
                .strikethrough(item.isCompleted)

            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(item.isCompleted ? Color.appSurfaceSubtle : Color.appSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(item.isCompleted ? Color.appPrimarySoft : Color.appBorder, lineWidth: 1)
        )
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
