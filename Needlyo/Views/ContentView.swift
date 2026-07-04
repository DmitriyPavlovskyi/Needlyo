//
//  ContentView.swift
//  Needlyo
//
//  Created by Dmytro Pavlovskyi1 on 04.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Майбутній Shopping List")
            Text("Створено вгадайте ким? 🤔")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
