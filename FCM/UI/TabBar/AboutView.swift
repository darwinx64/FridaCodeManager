 /* 
 Home.swift 

 Copyright (C) 2023, 2024 SparkleChan and SeanIsTethered 
 Copyright (C) 2024 fridakitten 

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
import UniformTypeIdentifiers

struct AboutView: View {
    var body: some View {
        NavigationView {
            List {
                versionSection
                changelogSection
                CreditsView()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("About", displayMode: .inline)
        }
        .navigationViewStyle(.stack)
    }

    private var versionSection: some View {
        Section {

        } header: {
            Label("Version \(global_version)", systemImage: "info.circle")
        }
    }
    
    private var changelogSection: some View {
        Section {
            VStack {
                Spacer().frame(height: 10)
                ScrollView {
                    Text(changelog)
                        .font(.system(size: 11))
                }
                Spacer()
            }
            .frame(height: 200)
        } header: {
            Label("Changelog", systemImage: "checklist")
        }
    }

    private func listItem(label: String, systemImageName: String, text: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(label).font(.headline)
                Text(text).font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            ZStack {
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .cornerRadius(4)
                Image(systemName: systemImageName)
                    .foregroundColor(Color(.systemBackground))
                    .frame(width: 20, height: 20)
            }
        }
    }
}

extension UTType {
    static var project: UTType { UTType(filenameExtension: "sproj")! }
}
