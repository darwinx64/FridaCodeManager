/*
 ProjectPrefsAppearanceView.swift

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

struct ProjectPrefsAppearanceView: View {
	@State var projname: String
	@State var projpath: String
	@State var restrict: Bool = false
	@State var portrait: Bool = false
	@State var landscape: Bool = false
	@State var iconid: UUID = UUID()
	var body: some View {
		List {
			ImgView(projpath: projpath, iconid: $iconid)
				.id(iconid)
			Section(header: Text("Orientation")) {
				Toggle("Restrict Orientation", isOn: $restrict)
					.tint(.orange)
				if restrict == true {
					Toggle("Portrait Mode", isOn: $portrait)
					Toggle("Landscape Mode", isOn: $landscape)
				}
			}
		}
		.listStyle(InsetGroupedListStyle())
		.onAppear {
			config()
		}
		.onChange(of: restrict) { _ in
			update()
		}
		.onChange(of: portrait) { _ in
			update()
		}
		.onChange(of: landscape) { _ in
			update()
		}
		.navigationTitle("Appearance")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func update() {
		let proj = "\(global_documents)/\(projname)"
		let plist = "\(proj)/Resources/Info.plist"
		let array = "UISupportedInterfaceOrientations"
		var items: [String] = []
		if restrict == true {
			if portrait == true {
				items.append("UIInterfaceOrientationPortrait")
			}
			if landscape == true {
				items.append("UIInterfaceOrientationLandscapeRight")
			}
			if paeplist(aname: array, path: plist) {
				_ = rmaplist(aname: array, path: plist)
			}
			_ = caplist(aname: array, path: plist, arrayData: items)
		} else {
			if paeplist(aname: array, path: plist) {
				_ = rmaplist(aname: array, path: plist)
			}
		}
	}

	private func config() {
		let proj = "\(global_documents)/\(projname)"
		let plist = "\(proj)/Resources/Info.plist"
		let array = "UISupportedInterfaceOrientations"
		if paeplist(aname: array, path: plist) {
			restrict = true
			if itemExistsInPlist(
				item: "UIInterfaceOrientationPortrait", arrayKey: array, plistPath: plist)
			{
				portrait = true
			}
			if itemExistsInPlist(
				item: "UIInterfaceOrientationLandscapeRight", arrayKey: array, plistPath: plist)
			{
				landscape = true
			}
		} else {
			restrict = false
		}
	}

	private func itemExistsInPlist(item: String, arrayKey: String, plistPath: String) -> Bool {
		if let plistData = FileManager.default.contents(atPath: plistPath),
			let plistDictionary = try? PropertyListSerialization.propertyList(
				from: plistData, options: [], format: nil) as? [String: Any],
			let array = plistDictionary[arrayKey] as? [String]
		{
			return array.contains(item)
		}
		return false
	}
}