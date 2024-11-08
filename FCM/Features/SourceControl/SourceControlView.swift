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
		List {
			if fromProjectList {
				NavigationLink(destination: EmptyView()) {
					Label("Clone Repository", systemImage: "document.on.document.fill")
				}
				NavigationLink(destination: EmptyView()) {
					Label("Link Account", systemImage: "link.badge.plus")
				}
			} else {
				NavigationLink(destination: EmptyView()) {
					Label("TBD", systemImage: "pencil")
				}
			}
		}
		.listStyle(InsetGroupedListStyle())
	}
}
