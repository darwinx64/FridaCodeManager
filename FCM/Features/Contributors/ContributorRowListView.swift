 /*
 ContributorRowListView.swift

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

struct ContributorRowListView: View {
    private let credits: [Contributor] = [
        Contributor("SeanIsNotAConstant", "Main Developer", "https://github.com/fridakitten.png"),
        Contributor("AppInstaller iOS", "Developer", "https://github.com/AppInstalleriOSGH.png"),
        Contributor("RoothideDev", "Contributor", "https://github.com/roothide.png"),
        Contributor("Snoolie", "Contributor", "https://github.com/0xilis.png"),
        Contributor("HAHALOSAH", "Contributor", "https://github.com/HAHALOSAH.png"),
        Contributor("darwinx64", "Contributor", "https://github.com/darwinx64.png"),
        Contributor("Manuel Chakravarty", "Contributor", "https://github.com/mchakravarty.png"),
        Contributor("Ayame Yumemi", "Icon Designer", "https://github.com/ayayame09.png"),
        Contributor("meighler", "Licensor", "https://github.com/meighler.png")
    ]

    private let sideCredits = [
        Contributor("Opa334", "Trollstore Helper", "https://github.com/opa334.png"),
        Contributor("Theos", "SDK", "https://github.com/theos.png")
    ]

    private let others = [
        Contributor("Chariz", "Repo Host", "https://github.com/chariz.png")
    ]

    var body: some View {
        ForEach([
            ("Credits", "heart", credits),
            ("Side Credits", "star", sideCredits),
            ("Others", "sparkles", others)
        ], id: \.0) { sectionHeader, sectionIcon, sectionContents in
            Section {
                ForEach(sectionContents, id: \.self) { contributor in
                    ContributorRowView(contributor: contributor)
                }
            } header: {
                Label(sectionHeader, systemImage: sectionIcon)
            }
        }
    }
}
