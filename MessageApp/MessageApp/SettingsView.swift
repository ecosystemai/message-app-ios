//
//  SettingsView.swift
//  MessageApp
//
//  Created by Jay van Zyl on 2024.11.05.
//

import SwiftUI

struct SettingsView: View {
//    @AppStorage(SettingsKeys.messagesApiUrl) private var messagesApiUrl: String = "http://localhost:8098/invocations"
//    @AppStorage(SettingsKeys.personalityApiUrl) private var personalityApiUrl: String = "http://localhost:8092/invocations"
//    @AppStorage(SettingsKeys.acceptanceApiUrl) private var acceptanceApiUrl: String = "http://localhost:8098/response"
    @AppStorage(SettingsKeys.messagesApiUrl) private var messagesApiUrl: String = "https://customerruntime8.ecosystem.ai/invocations"
    @AppStorage(SettingsKeys.personalityApiUrl) private var personalityApiUrl: String = "https://customerruntime2.ecosystem.ai/invocations"
    @AppStorage(SettingsKeys.acceptanceApiUrl) private var acceptanceApiUrl: String = "https://customerruntime8.ecosystem.ai/response"

    @AppStorage(SettingsKeys.webAppUrl) private var webAppUrl: String = "http://localhost:4200"
    
    var body: some View {
        Form {
            Section(header: Text("API URLs")) {
                TextField("Messages API URL", text: $messagesApiUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                TextField("Personality API URL", text: $personalityApiUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                TextField("Acceptance API URL", text: $acceptanceApiUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }
            
            Section(header: Text("Web App URL")) {
                TextField("Web App URL", text: $webAppUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }
        }
        .navigationTitle("Settings")
    }
}
