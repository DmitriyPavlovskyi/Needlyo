import SwiftUI

struct ShoppingItemRow: View {

    let item: ShoppingItem
    let isEditing: Bool
    @Binding var draftTitle: String
    let onToggleCompletion: () -> Void
    let onBeginEditing: () -> Void
    let onSaveEdit: () -> Void
    let onCancelEdit: () -> Void

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onToggleCompletion) {
                completionIndicator
            }
            .buttonStyle(.plain)
            .disabled(isEditing)

            if isEditing {
                TextField("Назва елемента", text: $draftTitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextPrimary)
                    .focused($isTitleFocused)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .onSubmit(onSaveEdit)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.appSurfaceSubtle)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.appPrimarySoft, lineWidth: 1)
                    )

                HStack(spacing: 8) {
                    Button(action: onSaveEdit) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(canSaveDraft ? Color.appPrimaryStrong : Color.appBorder)
                    }
                    .buttonStyle(.plain)
                    .disabled(!canSaveDraft)

                    Button(action: onCancelEdit) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.appDestructive)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Button(action: onBeginEditing) {
                    HStack(spacing: 0) {
                        Text(item.title)
                            .font(.subheadline)
                            .foregroundStyle(item.isCompleted ? Color.appTextSecondary : Color.appTextPrimary)
                            .strikethrough(item.isCompleted)

                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
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
        .onChange(of: isEditing) { _, newValue in
            if newValue {
                focusEditor()
            } else {
                isTitleFocused = false
            }
        }
        .onChange(of: isTitleFocused) { _, newValue in
            guard isEditing, !newValue else {
                return
            }

            DispatchQueue.main.async {
                if isEditing && !isTitleFocused {
                    onCancelEdit()
                }
            }
        }
        .onAppear {
            if isEditing {
                focusEditor()
            }
        }
        .onDisappear {
        }
    }

    private var completionIndicator: some View {
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

    private var canSaveDraft: Bool {
        !draftTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func focusEditor() {
        isTitleFocused = true
    }

}

#Preview {
    List {
        ShoppingItemRow(
            item: ShoppingItem(title: "Milk"),
            isEditing: false,
            draftTitle: .constant("Milk"),
            onToggleCompletion: {},
            onBeginEditing: {},
            onSaveEdit: {},
            onCancelEdit: {}
        )

        ShoppingItemRow(
            item: ShoppingItem(title: "Bread", isCompleted: true),
            isEditing: true,
            draftTitle: .constant("Bread"),
            onToggleCompletion: {},
            onBeginEditing: {},
            onSaveEdit: {},
            onCancelEdit: {}
        )
    }
}
