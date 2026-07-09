import SwiftUI

struct ShoppingListView: View {

    @State
    private var viewModel = ShoppingListViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground.ignoresSafeArea()

            List {
                if viewModel.visibleItems.isEmpty {
                    emptyState
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.visibleItems) { item in
                        ShoppingItemRow(
                            item: item,
                            onToggleCompletion: {
                                viewModel.toggleCompletion(for: item)
                            }
                        )
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
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .contentMargins(.top, 8, for: .scrollContent)
            .background(Color.appBackground)
            .safeAreaInset(edge: .top, spacing: 0) {
                topHeader
            }

            microphoneArea
        }
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

    private var topHeader: some View {
        VStack(spacing: 10) {
            Text("Що треба купити")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
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
                Text(viewModel.dictatedText.isEmpty ? "Слухаю..." : viewModel.dictatedText)
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
        .background(Color.appBackground.ignoresSafeArea(edges: .bottom))
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

        viewModel.deleteItems(at: IndexSet(integer: index))
    }

}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}