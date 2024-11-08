/*
 Color+RawRepresentable.swift

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
/// src: https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e
/// seems like `UINeoEditor.swift:1207` doesnt support a default value?
import Foundation
import SwiftUI
import UIKit

extension Color: RawRepresentable {
	public init?(rawValue: String) {
		guard let data = Data(base64Encoded: rawValue) else {
			self = .primary
			return
		}

		do {
			let color =
				try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .systemBlue
			self = Color(color)
		} catch {
			self = .primary
		}
	}

	public var rawValue: String {
		do {
			let data =
				try NSKeyedArchiver.archivedData(
					withRootObject: UIColor(self), requiringSecureCoding: false) as Data
			return data.base64EncodedString()
		} catch {
			return ""
		}
	}
}
