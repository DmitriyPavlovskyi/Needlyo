import SwiftUI

struct ShoppingListView: View {

    @State
    private var viewModel = ShoppingListViewModel()

    var body: some View {
        List {
            if viewModel.visibleItems.isEmpty {
                emptyState
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                Section {
                    ForEach(viewModel.visibleItems) { item in
                        ShoppingItemRow(
                            item: item,
                            onToggleCompletion: {
                                viewModel.toggleCompletion(for: item)
                            }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(item)
                            } label: {
                                Label("Видалити", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $viewModel.searchText, prompt: "Шукати товари...")
        .safeAreaInset(edge: .bottom) {
            microphoneArea
        }
        .navigationTitle("Що треба купити")
        .navigationBarTitleDisplayMode(.large)
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
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.secondary.opacity(0.35))

            Text("Список порожній")
                .font(.headline)

            Text("Натисни кнопку мікрофона та скажи що хочеш купити")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 120)
    }

    private var microphoneArea: some View {
        VStack(spacing: 8) {
            if viewModel.isListening {
                Text(viewModel.dictatedText.isEmpty ? "Слухаю..." : viewModel.dictatedText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(viewModel.isListening ? Color.red : Color.accentColor)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
            }
            .accessibilityLabel(viewModel.isListening ? "Зупинити голосовий ввід" : "Почати голосовий ввід")
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(.bar)
    }

    private func delete(_ item: ShoppingItem) {
        guard let index = viewModel.visibleItems.firstIndex(of: item) else {
            return
        }

        viewModel.deleteItems(at: IndexSet(integer: index))
    }

}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}
