/*
 SourceControlView.swift

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

struct SourceControlView: View {
	@State var fromProjectList: Bool = false
	var body: some View {
		NavigationView {
			List {
				if fromProjectList {
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Label("Clone", systemImage: "arrow.down.document.fill")
					}
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Label("Manage Accounts", systemImage: "person.2.badge.gearshape.fill")
					}
				} else {
					NavigationLink(destination: WikiPlaceholderDestination()) {
						Label("TBD", systemImage: "pencil")
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
		}
	}
}
