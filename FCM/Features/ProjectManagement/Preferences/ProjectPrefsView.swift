/*
 ProjectPrefsView.swift

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

struct ProjectPrefsView: View {
	@Binding var ProjectName: String
	@Binding var uuid: UUID
	@Binding var rname: String

	@State private var commitSheetIsPresented: Bool = false
	var body: some View {
		NavigationView {
			List {
				NavigationLink(
					destination: ProjectPrefsInfoView(ProjectName: $ProjectName, uuid: $uuid)
				) {
					Label("App Information", systemImage: "list.bullet.rectangle.fill")
				}
				NavigationLink(
					destination: ProjectPrefsAppearanceView(
						projname: ProjectName, projpath: "\(global_documents)/\(ProjectName)")
				) {
					Label("Appearance", systemImage: "paintbrush.fill")
				}
				NavigationLink(
					destination: ProjectSDKChangeView(projpath: "\(global_documents)/\(ProjectName)")
				) {
					Label("SDK", systemImage: "sdcard.fill")
				}
				Section {
					Button { commitSheetIsPresented = true } label: {
						Label("Commit", systemImage: "paintbrush.fill")
					}
				} header: {
					Label("Source Control", systemImage: "curlybraces.square")
				}
			}
			.sheet(isPresented: $commitSheetIsPresented) {
				Button { commitSheetIsPresented = false } label: {
					Text("Commit")
				}
				.buttonStyle(.borderedProminent)
				.controlSize(.large)
				Button { commitSheetIsPresented = false } label: {
					Text("Cancel")
				}
				.tint(.red)
				.buttonStyle(.bordered)
				.controlSize(.large)
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("\(rname)")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct ProjectSDKChangeView: View {
	@State var projpath: String
	@State private var sdk: String = ""
	@State private var isActive: Bool = false
	var body: some View {
		List {
			Text("\(sdk)")
			NavigationLink(
				destination: SDKList(
					directoryPath: URL(fileURLWithPath: global_sdkpath), sdk: $sdk, isActive: $isActive),
				isActive: $isActive
			) {
				Text("Change")
			}
		}
		.onChange(of: sdk) { _ in
			_ = wplist(value: sdk, forKey: "SDK", plistPath: "\(projpath)/Resources/DontTouchMe.plist")
		}
		.onAppear {
			if sdk == "" {
				sdk =
					(rplist(forKey: "SDK", plistPath: "\(projpath)/Resources/DontTouchMe.plist") ?? "")
			}
		}
		.listStyle(InsetGroupedListStyle())
		.navigationTitle("SDK")
		.navigationBarTitleDisplayMode(.inline)
	}
}
