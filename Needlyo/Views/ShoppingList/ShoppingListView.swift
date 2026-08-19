import SwiftUI

struct ShoppingListView: View {

    @State
    private var viewModel = ShoppingListViewModel()
    @State private var editingItemID: ShoppingItem.ID?
    @State private var draftTitle = ""
    @State private var showingClearConfirmation = false

    var body: some View {
        ScrollViewReader { proxy in
            List {
                if viewModel.visibleItems.isEmpty {
                    emptyState
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.visibleItems) { item in
                        ShoppingItemRow(
                            item: item,
                            isEditing: editingItemID == item.id,
                            draftTitle: Binding(
                                get: {
                                    editingItemID == item.id ? draftTitle : item.title
                                },
                                set: { newValue in
                                    guard editingItemID == item.id else {
                                        return
                                    }

                                    draftTitle = newValue
                                }
                            ),
                            onToggleCompletion: {
                                viewModel.toggleCompletion(for: item)
                            },
                            onBeginEditing: {
                                beginEditing(item)
                            },
                            onSaveEdit: {
                                saveEditing()
                            },
                            onCancelEdit: {
                                cancelEditing()
                            }
                        )
                        .id(item.id)
                        .listRowInsets(EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                delete(item)
                            } label: {
                                Label("Видалити", systemImage: "trash")
                            }
                            .tint(Color.appDestructive)
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
            .gesture(
                TapGesture().onEnded {
                    if editingItemID != nil {
                        cancelEditing()
                    }
                }
            )
            .onChange(of: editingItemID) { _, newValue in
                guard let editingItemID = newValue else {
                    return
                }

                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        proxy.scrollTo(editingItemID, anchor: .center)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .contentMargins(.top, 8, for: .scrollContent)
        .background(Color.appBackground)
        .safeAreaInset(edge: .top, spacing: 0) {
            topHeader
                .gesture(
                    TapGesture().onEnded {
                        if editingItemID != nil {
                            cancelEditing()
                        }
                    }
                )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if editingItemID == nil {
                microphoneArea
                    .gesture(
                        TapGesture().onEnded {
                            if editingItemID != nil {
                                cancelEditing()
                            }
                        }
                    )
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .alert(
            "Голосовий ввід недоступний",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .confirmationDialog(
            "Очистити список?",
            isPresented: $showingClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Очистити", role: .destructive) {
                clearList()
            }

            Button("Скасувати", role: .cancel) {}
        } message: {
            Text("Усі товари буде видалено з цього списку. Цю дію не можна скасувати.")
        }
    }

    private var topHeader: some View {
        ZStack(alignment: .trailing) {
            Text("Що треба купити")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .center)

            if !viewModel.visibleItems.isEmpty {
                Button {
                    showingClearConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.appDestructive)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Очистити список")
                .accessibilityHint("Видалити всі товари зі списку")
                .padding(.trailing, 10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(Color.appBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.appBorder)
                .frame(height: 1)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(Color.appPrimarySoft)

            Text("Список порожній")
                .font(.headline)
                .foregroundStyle(Color.appTextPrimary)

            Text("Натисни кнопку мікрофона та скажи що хочеш купити")
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 120)
        .padding(.horizontal, 32)
    }

    private var microphoneArea: some View {
        VStack(spacing: 8) {
            if viewModel.isListening {
                Text(viewModel.dictatedText.isEmpty ? "Говоріть..." : viewModel.dictatedText)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Button {
                Task {
                    await viewModel.toggleListening()
                }
            } label: {
                Image(systemName: viewModel.isListening ? "stop.fill" : "mic.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.appPrimaryText)
                    .frame(width: 60, height: 60)
                    .background(viewModel.isListening ? Color.appPrimaryStrong : Color.appPrimary)
                    .clipShape(Circle())
            }
            .accessibilityLabel(viewModel.isListening ? "Зупинити голосовий ввід" : "Почати голосовий ввід")
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .padding(.horizontal, 16)
        .background(Color.appBackground)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.appBorder)
                .frame(height: 1)
        }
    }

    private func delete(_ item: ShoppingItem) {
        guard let index = viewModel.visibleItems.firstIndex(of: item) else {
            return
        }

        if editingItemID == item.id {
            cancelEditing()
        }

        viewModel.deleteItems(at: IndexSet(integer: index))
    }

    private func clearList() {
        cancelEditing()
        viewModel.clearAllItems()
    }

    private func beginEditing(_ item: ShoppingItem) {
        editingItemID = item.id
        draftTitle = item.title
    }

    private func saveEditing() {
        guard let editingItemID,
              let item = viewModel.visibleItems.first(where: { $0.id == editingItemID }) else {
            cancelEditing()
            return
        }

        viewModel.updateTitle(for: item, to: draftTitle)
        cancelEditing()
    }

    private func cancelEditing() {
        editingItemID = nil
        draftTitle = ""
    }

}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}