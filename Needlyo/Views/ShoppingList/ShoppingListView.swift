import SwiftUI

struct ShoppingListView: View {

    @State
    private var viewModel = ShoppingListViewModel()

    var body: some View {

        VStack(spacing: 24) {

            Spacer()

            Image(systemName: "cart.fill")

                .font(.system(size: 60))

                .foregroundStyle(.blue)

            Text("Needlyo")

                .font(.largeTitle)

                .fontWeight(.bold)

            Text("Your shopping list starts here.")

                .foregroundStyle(.secondary)

            Spacer()

        }

        .navigationTitle("Ой, а хто тут? 🤔")

    }

}

#Preview {

    NavigationStack {

        ShoppingListView()

    }

}
