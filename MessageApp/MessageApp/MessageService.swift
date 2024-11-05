//
//  MessageService.swift
//  MessageApp
//
//  Created by Jay van Zyl on 2024.11.05.
//

import Foundation

class MessageService {
    static let shared = MessageService()

    private var messagesApiUrl: URL {
        URL(string: UserDefaults.standard.string(forKey: SettingsKeys.messagesApiUrl) ?? "https://customerruntime8.ecosystem.ai/invocations")!
    }
    private var personalityApiUrl: URL {
        URL(string: UserDefaults.standard.string(forKey: SettingsKeys.personalityApiUrl) ?? "https://customerruntime2.ecosystem.ai/invocations")!
    }
    private var acceptanceApiUrl: URL {
        URL(string: UserDefaults.standard.string(forKey: SettingsKeys.acceptanceApiUrl) ?? "https://customerruntime8.ecosystem.ai/response")!
    }

    func fetchPersonality(customerNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: personalityApiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "campaign": "spend_personality",
            "subcampaign": "api",
            "channel": "app",
            "customer": customerNumber,
            "userid": "apple",
            "numberoffers": 1,
            "params": "{}"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? NSError()))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let result = json["final_result"] as? [[String: Any]],
               let trait = result.first?["result_full"] as? [String: Any],
               let personality = trait["trait"] as? String {
                completion(.success(personality))
            } else {
                completion(.failure(NSError(domain: "ParsingError", code: -1, userInfo: nil)))
            }
        }.resume()
    }

    // fetch messages with campaign set to "budget_messages" and sorted by result score
    func fetchMessages(customerNumber: String, personality: String, completion: @escaping (Result<[String], Error>) -> Void) {
        var request = URLRequest(url: messagesApiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "campaign": "budget_messages",
            "subcampaign": "none",
            "channel": "app",
            "customer": "none",
            "userid": "apple",
            "numberoffers": 4,
            "params": [
                "input": ["contextual_variable_one", "contextual_variable_two"],
                "value": [personality, ""]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? NSError()))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let result = json["final_result"] as? [[String: Any]] {
                
                // Sort the messages based on "result score" in descending order
                let sortedMessages = result.sorted { lhs, rhs in
                    let lhsScore = lhs["result_score"] as? Double ?? 0.0
                    let rhsScore = rhs["result_score"] as? Double ?? 0.0
                    return lhsScore > rhsScore
                }

                // Extract the sorted messages as strings or based on desired format
                let messages = sortedMessages.compactMap { $0["result"] as? String }
                completion(.success(messages))
            } else {
                completion(.failure(NSError(domain: "ParsingError", code: -1, userInfo: nil)))
            }
        }.resume()
    }
}
