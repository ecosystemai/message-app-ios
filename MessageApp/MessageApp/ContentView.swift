//
//  ContentView.swift
//  MessageApp
//
//  Created by Jay van Zyl on 2024.11.05.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(SettingsKeys.webAppUrl) private var webAppUrl: String = "http://localhost:4200"

    var body: some View {
        WebView(url: URL(string: webAppUrl)!)
            .edgesIgnoringSafeArea(.all)
    }
}
