/*
 ProjectView.swift

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

struct ProjectListView: View {
	@Binding var uuid: UUID
	@State private var Prefs: Bool = false
	@State private var Removal: Bool = false
	@State private var projname: String = ""
	@State private var projrname: String = ""
	@State private var pathstate: String = ""
	@State private var action: Int = 0
	@State private var fileImporter = false
	@State private var showProj = false

	@Environment(\.presentationMode) private var presentationMode

	@State var AppName: String = ""
	@State var BundleID: String = ""

	#if jailbreak
	@State private var type = 1
	#elseif trollstore || stock
	@State private var type = 2
	#endif

	@Binding var Projects: [Project]
	var body: some View {
		NavigationView {
			List {
				ForEach(Dictionary(grouping: Projects, by: { $0.TYPE }).sorted(by: { $0.key < $1.key }), id: \.key) { type, projects in
					Section(header: Text(type)) {
						ForEach(projects) { Project in
							NavigationLink(destination: CodeSpace(ProjectInfo: Project, pathstate: $pathstate, action: $action)) {
								HStack {
									if (Project.BundleID == "Corrupted") {
										VStack {
											Image(systemName: "questionmark.folder")
										}.frame(width: 40, height: 40)
									} else {
										PubImg(projpath: "\(global_documents)/\(Project.Name)")
									}
									Spacer().frame(width: 15)
									VStack(alignment: .leading) {
										Text(Project.Executable)
											.font(.system(size: 16))
										Text(Project.BundleID)
											.font(.system(size: 12))
											.opacity(0.5)
								   }
								}
								.contextMenu {
									Section {
										Button(action: {
											app_btn(Project)
										}) {
											Label("Export App", systemImage: "app")
										}
										Button(action: {
											proj_btn(Project)
										}) {
											Label("Export Project", systemImage: "archivebox")
										}
									}
									Button(action: {
										projname = Project.Name
										projrname = Project.Executable
										Prefs = true
									}) {
										Label("Project Preferences", systemImage: "gear")
									}
									Section {
										Button(role: .destructive, action: {
											projname = "\(global_documents)/\(Project.Name)"
											projrname = "Remove \"\(Project.Executable)\"?"
											DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
												Removal = true
											}
										}) {
											Label("Remove", systemImage: "trash")
										}
									}
								}
						   }
					   }
					}
				}.onDelete(perform: deleteProjectPrompt)
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle("Projects")
			.fileImporter(isPresented: $fileImporter, allowedContentTypes: [.project], onCompletion: handleFileImport)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						AppName = ""
						BundleID = ""
						showProj = true
					}) {
						Image(systemName: "folder.fill.badge.plus")
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						fileImporter = true
					}) {
						Image(systemName: "square.and.arrow.down.fill")
					}
				}
			}
			.sheet(isPresented: $Prefs) {
				ProjectPrefsView(ProjectName: $projname, uuid: $uuid, rname: $projrname)
					.onDisappear {
						uuid = UUID()
					}
			}
			.sheet(isPresented: $Removal) {
				BottomPopupView {
					POBHeader(title: $projrname)
					Spacer().frame(height: 10)
					POButtonBar(cancel: Cancel_trigger, confirm: Removal_trigger)
				}
				.background(BackgroundClearView())
				.edgesIgnoringSafeArea([.bottom])
			}
			.sheet(isPresented: $showProj) {
				BottomPopupView {
					POHeader(title: "Create Project")
					POTextField(title: "Application Name", content: $AppName)
					POTextField(title: "Bundle Identifier", content: $BundleID)
					POPicker(function: createProject_trigger, title: "Scheme", arrays: [PickerArrays(title: "App", items: [PickerItems(id: 1, name: "Swift"), PickerItems(id: 2, name: "ObjC"), PickerItems(id: 3, name: "Swift/ObjC"), PickerItems(id: 5, name: "Swift/C++")]), PickerArrays(title: "Binary", items: [PickerItems(id: 4, name: "C")])], type: $type)
				}
				.background(BackgroundClearView())
				.edgesIgnoringSafeArea([.bottom])
			}
		}
	}

    private func deleteProjectPrompt(at offsets: IndexSet) {
        for index in offsets {
            let Project = Projects[index]
            projname = "\(global_documents)/\(Project.Name)"
            projrname = "Remove \"\(Project.Executable)\"?"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                Removal = true
            }
        }
    }

	private func handleFileImport(result: Result<URL, Error>) -> Void {
		switch result {
		case .success(let fileURL):
			importProj(target: fileURL.path)
			uuid = UUID()
		case .failure(let error):
			print("Error importing file: \(error.localizedDescription)")
		}
	}

	private func createProject_trigger() -> Void {
		if AppName != "", BundleID != "" {
			haptfeedback(1)
			showProj = false
			_ = MakeApplicationProject(AppName, BundleID, type: type)
			(AppName, BundleID, uuid) = ("", "", UUID())
		} else {
			haptfeedback(2)
		}
	}

	private func app_btn(_ Project: Project) -> Void {
		DispatchQueue.global(qos: .utility).async {
			ShowAlert(UIAlertController(title: "Building \(Project.Executable)", message: "", preferredStyle: .alert))
			if exportApp(Project) == 0 {
				DismissAlert {
					let modname = Project.Executable.replacingOccurrences(of: " ", with: "_")
					if let stabURL = URL(string: "file://\(global_container)/tmp/\(modname).ipa") {
						share(url: stabURL)
					}
				}
			} else { DismissAlert() }
		}
	}

	private func proj_btn(_ Project: Project) -> Void {
		DispatchQueue.global(qos: .utility).async {
			ShowAlert(UIAlertController(title: "Exporting \(Project.Executable)", message: "", preferredStyle: .alert))
			if exportProj(Project) == 0 {
				DismissAlert {
					let modname = Project.Executable.replacingOccurrences(of: " ", with: "_")
					if let stabURL = URL(string: "file://\(global_container)/tmp/\(modname).sproj") {
						share(url: stabURL)
					}
				}
			} else { DismissAlert() }
		}
	}

	private func Removal_trigger() -> Void {
		haptfeedback(1)
		_ = rm("\(projname)")
		uuid = UUID()
		Removal = false
	}

	private func Cancel_trigger() -> Void {
		Removal = false
	}

	private func exportProj(_ project: Project) -> Int {
		let modname = project.Executable.replacingOccurrences(of: " ", with: "_")
		_ = rm("\(global_container)/tmp/\(modname).sproj")
		let result: Int = Int(libzip_zip("\(global_documents)/\(project.Name)","\(global_documents)/\(modname).sproj", true))
		if result == 0 {
			_ = mv("\(global_documents)/\(modname).sproj", "\(global_container)/tmp/\(modname).sproj")
		}
		return result
	}

	private func exportApp(_ project: Project) -> Int {
		#if !stock
		let result = build(project, false, nil, nil)
		#else
		let result = 0
		#endif
		let modname = project.Executable.replacingOccurrences(of: " ", with: "_")
		if result == 0 {
			_ = rm("\(global_container)/tmp/\(modname).ipa")
			_ = mv("\(global_documents)/\(project.Name)/ts.ipa", "\(global_container)/tmp/\(modname).ipa")
		}
		return result
	}
}

struct CodeSpace: View {
	@State var ProjectInfo: Project
	@State var buildv: Bool = false
	@Binding var pathstate: String
	@Binding var action: Int
	var body: some View {
		FileList(title: ProjectInfo.Executable, directoryPath: URL(fileURLWithPath: ProjectInfo.ProjectPath), buildv: $buildv, actpath: $pathstate, action: $action, project: ProjectInfo)
			.fullScreenCover(isPresented: $buildv) {
				switch ProjectInfo.TYPE {
					case "Applications":
					   buildView(ProjectInfo: ProjectInfo, buildv: $buildv)
					case "Utilities":
					   buildView(ProjectInfo: ProjectInfo, buildv: $buildv)
					case "Sean16":
					   sean16View(ProjectInfo: ProjectInfo, buildv: $buildv)
					default:
					   Spacer()
				}
			}
	}
}

struct buildView: View {
	@State var ProjectInfo: Project
	@Binding var buildv: Bool
	@State private var compiling: Bool = true
	@State private var BVstatus: String = ""
	@State private var BVprogress = 0.0

	@State private var Log: [LogItem] = []
	@State private var LogCache: [LogItem] = []
	@State private var Cache: [logstruct] = []
	var body: some View {
		VStack {
			NeoLog(buildv: $buildv, LogItems: $Log, LogCache: $LogCache, LogViews: $Cache) {
				DispatchQueue.global(qos: .utility).async {
					killallchilds()

					compiling = true
					#if !stock
					let status = build(ProjectInfo, true, $BVstatus, $BVprogress)
					#else
					let status = build(ProjectInfo, false, $BVstatus, $BVprogress)
					#endif
					DispatchQueue.main.async {
						if status == 0 {
							Cache.append(logstruct(file: " ", line: 0, level: -1, description: "Success", detail: "successfully build app"))
							#if !stock
							if ProjectInfo.TYPE == "Applications" {
								OpenApp(ProjectInfo.BundleID)
							}
							#else
							print("[*] you have to export the app!\n")
							#endif
						} else {
							if Cache.isEmpty {
								Cache.append(logstruct(file: " ", line: 0, level: 2, description: "Fatal Error", detail: "none-zero compiler return, for more details switch to log mode"))
							}
						}
						withAnimation {
							BVstatus = "Done :3"
							BVprogress = 1.0
							compiling = false
						}
					}
				}
		    }
			ZStack {
				Rectangle()
					.foregroundColor(Color(UIColor.systemGray6))
					.cornerRadius(15)
				VStack {
					ProgressView(value: BVprogress, total: 1.0)
						.progressViewStyle(LinearProgressViewStyle())
						.frame(width: UIScreen.main.bounds.width / 1.4)
					Spacer().frame(height: 10)
					Text("\(BVstatus)")
						.font(.system(size: 11, weight: .semibold))
				}
			}
			.frame(width: UIScreen.main.bounds.width / 1.2, height: 65)
			if !UIDevice.current.hasNotch {
				Spacer().frame(height: 25)
			}
		}
	}
}

struct sean16View: View {
	@State var ProjectInfo: Project
	@Binding var buildv: Bool

	var body: some View {
		VStack {
			ScreenEmulatorUIView()
				.frame(width: screenWidth, height: screenWidth)
				.onAppear {
					serialQueue.async {
						runtime_sean16(ProjectInfo)
					}
				}
			//NeoLog(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 4)
			Spacer().frame(height: 25)
			Button( action: {
				send_cpu(1)
				buildv = false
			}){
				ZStack {
					Rectangle()
						.foregroundColor(.red)
						.cornerRadius(15)
					Text("Abort")
						.foregroundColor(.white)
				}
			}
			.frame(width: UIScreen.main.bounds.width / 1.2, height: 50)
		}
	}
}

func copyToClipboard(text: String, alert: Bool? = true) {
	haptfeedback(1)
	
	if (alert ?? true) {
		let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)

		let attachment = NSTextAttachment()
		attachment.image = UIImage(systemName: "checkmark")?.withTintColor(.label)

		let symbolSize = UIFont.systemFont(ofSize: 16)
		attachment.bounds = CGRect(x: 0, y: -4, width: symbolSize.pointSize, height: symbolSize.pointSize)
		
		let attributedTitle = NSMutableAttributedString(attachment: attachment)
		attributedTitle.append(NSAttributedString(string: " Copied", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold)]))

		alert.setValue(attributedTitle, forKey: "attributedTitle")

		ShowAlert(alert)
	}

	UIPasteboard.general.string = text

	if (alert ?? true) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			DismissAlert()
		}
	}
}

func share(url: URL) -> Void {
	let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
	activityViewController.modalPresentationStyle = .popover

	DispatchQueue.main.async {
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			if let rootViewController = windowScene.windows.first?.rootViewController {
				if let popoverController = activityViewController.popoverPresentationController {
					popoverController.sourceView = rootViewController.view
					popoverController.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
													  y: rootViewController.view.bounds.midY,
													  width: 0, height: 0)
					popoverController.permittedArrowDirections = []
				}
				rootViewController.present(activityViewController, animated: true, completion: nil)
			} else {
				print("No root view controller found.")
			}
		} else {
			print("No window scene found.")
		}
	}
}
