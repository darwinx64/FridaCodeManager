/*
 CleanerView.swift

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

struct CleanerView: View {
	var body: some View {
		List {
			Button(action: {
				clean(1)
			}) {
				Label("Clean Module Cache", systemImage: "trash.fill")
			}
			Button(action: {
				clean(2)
			}) {
				Label("Clean Temporary Data", systemImage: "trash.fill")
			}
		}
		.navigationTitle("Cleaner")
		.navigationBarTitleDisplayMode(.inline)
	}

	private func clean(_ arg: Int) {
		DispatchQueue.global(qos: .utility).async {
			ShowAlert(UIAlertController(title: "Cleaning", message: "", preferredStyle: .alert))
			let path: String = {
				switch arg {
				case 1:
					return "\(global_documents)/../.cache"
				case 2:
					return "\(global_documents)/../tmp"
				default:
					return "\(global_documents)/../.cache"
				}
			}()
			if FileManager.default.fileExists(atPath: path) {
				do {
					try adv_rm(atPath: path)
				} catch {
				}
			}
			DismissAlert()
		}
	}
}
