 /*
 SymbolView.swift

 Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered
 Copyright (C) 2024 fridakitten

 This file is part of FridaCodeManager.

 FridaCodeManager is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 FridaCodeManager is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with FridaCodeManager. If not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI
import UIKit

struct SFSymbolView: View {
    var body: some View {
        List {
            NavigationLink( destination: SFSymbolListView(symbols: gSFSymbols())) {
                Text("All")
            }
            Section(header: Text("categories")) {
                NavigationLink( destination: SFSymbolListView(symbols: gcommunication())) {
                    Label("Communication", systemImage: "bubble.left.and.bubble.right.fill")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gweather())) {
                    Label("Weather", systemImage: "cloud.moon.rain.fill")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gdevices())) {
                    Label("Devices", systemImage: "earbuds.case.fill")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gconnectivity())) {
                    Label("Connectivity", systemImage: "network")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gtransportation())) {
                    Label("Transportation", systemImage: "airplane")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gnature())) {
                    Label("Nature", systemImage: "leaf.fill")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gtextFormatting())) {
                    Label("Text Formatting", systemImage: "textformat")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gediting())) {
                    Label("Editing", systemImage: "pencil")
                }
                NavigationLink( destination: SFSymbolListView(symbols: gprivacyAndSecurity())) {
                    Label("Privacy & Security", systemImage: "shield.righthalf.filled")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("SFSymbols")
        .navigationBarTitleDisplayMode(.inline)
    }
}

class SymbolStore: ObservableObject {
    @Published var symbols: [String]
    
    init(symbols: [String]) {
        self.symbols = symbols
    }
}

struct SFSymbolListView: View {
    @State var symbols: [String]
    @StateObject var symbolStore = SymbolStore(symbols: symbols)
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(symbolStore.symbols, id: \.self) { symbolName in
                    Button(action: {
                        copyToClipboard(text: symbolName)
                    }) {
                        HStack {
                            Image(systemName: symbolName)
                                .frame(width: 30, height: 30)
                            Spacer()
                            Text(symbolName)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("SF Symbols")
        .navigationBarTitleDisplayMode(.inline)
        //.listStyle(InsetGroupedListStyle())
    }
}
