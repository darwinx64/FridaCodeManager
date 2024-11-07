/*
 WikiView.swift

 Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered
 Copyright (C) 2024 fridakitten
 Copyright (C) 2024 darwinx64

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

struct WikiPlaceholderDestination: View {
	var body: some View {
		Text("TBD")
	}
}

struct WikiView: View {
	var body: some View {
		NavigationView {
			List {
				// TODO: Implement destinations, maybe from an API somehow on https://fridacodemanager.github.io?
				Section {
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Text("Introduction")
					}
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Text("Features and Limitations")
					}
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Text("Installation")
					}
				} header: {
					Label("Prologue", systemImage: "info.circle")
				}
				Section {
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Text("Basic Usage")
					}
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Text("Advanced Usage")
					}
				} header: {
					Label("User Guide", systemImage: "text.book.closed")
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Wiki")
		}.navigationViewStyle(.stack)
	}
}
