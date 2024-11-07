/*
 ContributorRowView.swift

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

struct ContributorRowView: View {
	@State var contributor: Contributor
	var body: some View {
		HStack {
			AsyncImageLoaderView(urlString: contributor.avatar, width: 50, height: 50)
				.shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
			Spacer()
			VStack {
				Text(contributor.name)
					.foregroundColor(.primary)
					.font(.system(size: 14, weight: .bold))
				Text(contributor.description)
					.foregroundColor(.secondary)
					.font(.system(size: 12, weight: .semibold))
			}.frame(width: 200)
			Spacer()
		}
	}
}