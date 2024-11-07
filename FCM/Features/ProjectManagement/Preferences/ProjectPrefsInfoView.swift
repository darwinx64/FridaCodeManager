/*
 ProjectPrefsInfoView.swift

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

struct ProjectPrefsInfoView: View {
	@Binding var ProjectName: String
	@Binding var uuid: UUID
	@State var PlistPath: String = ""
	@State var AppName: String = ""
	@State var AppliName: String = ""
	@State var BundleID: String = ""
	@State var Version: String = ""
	@State var MIOS: String = ""
	@State var rfresh: UUID = UUID()
	var body: some View {
		List {
			Section(header: Text("Application Name")) {
				TextField("Application Name", text: $AppliName)
					.onSubmit {
						save()
					}
			}
			Section(header: Text("Display Name")) {
				TextField("Display Name", text: $AppName)
					.onSubmit {
						save()
					}
			}
			Section(header: Text("BundleID")) {
				TextField("BundleID", text: $BundleID)
					.onSubmit {
						save()
					}
			}
			Section(header: Text("Version")) {
				TextField("Version", text: $Version)
					.onSubmit {
						save()
					}
			}
			Section(header: Text("Minimum Deployment Target")) {
				TextField("Minimum Deployment Target", text: $MIOS)
					.onSubmit {
						save()
					}
			}
		}
		.id(rfresh)
		.onAppear {
			PlistPath = "\(global_documents)/\(ProjectName)/Resources/Info.plist"
			(AppName, AppliName, BundleID, Version, MIOS) = (
				(rplist(forKey: "CFBundleName", plistPath: PlistPath) ?? ""),
				(rplist(forKey: "CFBundleExecutable", plistPath: PlistPath) ?? ""),
				(rplist(forKey: "CFBundleIdentifier", plistPath: PlistPath) ?? ""),
				(rplist(forKey: "CFBundleVersion", plistPath: PlistPath) ?? ""),
				(rplist(forKey: "MinimumOSVersion", plistPath: PlistPath) ?? "")
			)
			rfresh = UUID()
		}
		.listStyle(InsetGroupedListStyle())
		.navigationTitle("App Information")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func save() {
		let keys = [
			"CFBundleName", "CFBundleExecutable", "CFBundleIdentifier", "CFBundleVersion",
			"CFBundleShortVersionString", "MinimumOSVersion",
		]
		let values = [AppName, AppliName, BundleID, Version, Version, MIOS]

		for i in 0..<keys.count {
			_ = wplist(value: values[i], forKey: keys[i], plistPath: PlistPath)
		}

		uuid = UUID()
	}
}
