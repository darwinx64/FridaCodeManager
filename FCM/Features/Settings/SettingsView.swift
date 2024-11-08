/*
 SettingsView.swift

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

struct SettingsView: View {
	@AppStorage("sdk") var sdk: String = "iPhoneOS15.6.sdk"
	@State private var fontstate: CGFloat = {
		if let savedFont = UserDefaults.standard.value(forKey: "savedfont") as? CGFloat {
			return savedFont
		} else {
			return 13.0
		}
	}()
	@State private var isActive: Bool = false

	var body: some View {
		NavigationView {
			List {
				NavigationLink(destination: AboutView()) {
					Label("About FridaCodeManager", systemImage: "info.circle")
				}
				Section {
					NavigationLink(
						destination: SDKList(
							directoryPath: URL(fileURLWithPath: global_sdkpath), sdk: $sdk,
							isActive: $isActive), isActive: $isActive
					) {
						Text(sdk)
					}
				} header: {
					Label("Default SDK", systemImage: "hammer.circle")
				}
				Section {
					NavigationLink(destination: DisplaySettingsView()) {
						Label("Display", systemImage: "paintbrush.fill")
					}
					NavigationLink(destination: EmptyView()) {
						Label("App Icon", systemImage: "app.dashed")
					}
				} header: {
					Label("General", systemImage: "gearshape")
				}
				Section {
					NavigationLink(destination: NeoEditorSettings()) {
						Label("Code Editor", systemImage: "chevron.left.forwardslash.chevron.right")
					}
					NavigationLink(destination: AuthorSettings()) {
						Label("Code Author", systemImage: "person.fill")
					}
					NavigationLink(destination: CleanerView()) {
						Label("Cleaner", systemImage: "trash.fill")
					}
				} header: {
					Label("Advanced", systemImage: "gearshape.2")
				}
				Section {
					NavigationLink(destination: SDKDownloadView()) {
						Label("SDK Hub", systemImage: "arrow.down")
					}
					NavigationLink(destination: SFSymbolView()) {
						Label("SF Symbols", systemImage: "square.grid.3x3.fill")
					}
				} header: {
					Label("Additional Tools", systemImage: "sparkles")
				}
			}
			.accentColor(.secondary)
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Settings")
		}
		.navigationViewStyle(.stack)
	}
}

struct AuthorSettings: View {
	@AppStorage("Author") var author: String = "Anonym"
	var body: some View {
		List {
			TextField("Your Name", text: $author)
		}
		.navigationTitle("Author")
		.navigationBarTitleDisplayMode(.inline)
	}
}
