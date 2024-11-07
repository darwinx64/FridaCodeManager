/*
 RootView.swift

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

struct RootView: View {
	@State private var project_list_id: UUID = UUID()
	@State private var projects: [Project] = []

	var body: some View {
		TabView {
			ProjectView(hello: $project_list_id, Projects: $projects)
				.tabItem {
					Label("Projects", systemImage: "folder")
				}
			WikiView()
				.tabItem {
					Label("Wiki", systemImage: "book.fill")
				}
			SettingsView()
				.tabItem {
					Label("Settings", systemImage: "gear")
				}
		}
		.onOpenURL { url in
			importProj(target: url.path)
			project_list_id = UUID()
		}
		.onChange(of: project_list_id) { _ in
			GetProjectsBind(Projects: $projects)
		}
		.onAppear {
			GetProjectsBind(Projects: $projects)
		}
	}
}

func GetProjectsBind(Projects: Binding<[Project]>) {
	DispatchQueue.global(qos: .background).async {
		do {
			let currentProjects = Projects.wrappedValue
			var foundProjectNames = Set<String>()

			for Item in try FileManager.default.contentsOfDirectory(atPath: global_documents) {
				if Item == "Inbox" || Item == "savedLayouts.json" || Item == ".sdk" || Item == ".cache"
					|| Item == "virtualFS.dat"
				{
					continue
				}

				foundProjectNames.insert(Item)

				let infoPlistPath = "\(global_documents)/\(Item)/Resources/Info.plist"
				let dontTouchMePlistPath = "\(global_documents)/\(Item)/Resources/DontTouchMe.plist"

				var BundleID = "Corrupted"
				var Version = "Unknown"
				var Executable = "Unknown"
				var TG = "Unknown"
				var SDK = "Unknown"
				var TYPE = "Applications"

				if let Info = NSDictionary(contentsOfFile: infoPlistPath) {
					if let extractedBundleID = Info["CFBundleIdentifier"] as? String {
						BundleID = extractedBundleID
					}
					if let extractedVersion = Info["CFBundleVersion"] as? String {
						Version = extractedVersion
					}
					if let extractedExecutable = Info["CFBundleExecutable"] as? String {
						Executable = extractedExecutable
					}
					if let extractedTG = Info["MinimumOSVersion"] as? String {
						TG = extractedTG
					}
				}

				if let Info2 = NSDictionary(contentsOfFile: dontTouchMePlistPath) {
					if let extractedSDK = Info2["SDK"] as? String {
						SDK = extractedSDK
					}
					if let extractedTYPE = Info2["TYPE"] as? String {
						TYPE = extractedTYPE
					}
				}

				let newProject = Project(
					Name: Item, BundleID: BundleID, Version: Version,
					ProjectPath: "\(global_documents)/\(Item)", Executable: Executable, SDK: SDK, TG: TG,
					TYPE: TYPE)

				if let existingIndex = currentProjects.firstIndex(where: { $0.Name == Item }) {
					let existingProject = currentProjects[existingIndex]
					if existingProject != newProject {
						usleep(500)
						DispatchQueue.main.async {
							withAnimation {
								Projects.wrappedValue[existingIndex] = newProject
							}
						}
					}
				} else {
					usleep(500)
					DispatchQueue.main.async {
						withAnimation {
							Projects.wrappedValue.append(newProject)
						}
					}
				}
			}

			usleep(500)
			DispatchQueue.main.async {
				withAnimation {
					Projects.wrappedValue.removeAll { project in
						!foundProjectNames.contains(project.Name)
					}
				}
			}
		} catch {
			print(error)
		}
	}
}
