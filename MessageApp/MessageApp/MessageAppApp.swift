//
//  MessageAppApp.swift
//  MessageApp
//
//  Created by Jay van Zyl on 2024.11.05.
//

import SwiftUI

@main
struct MessageAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationBarItems(trailing: NavigationLink("Settings", destination: SettingsView()))
            }
        }
    }
}
