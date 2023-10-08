//
//  ChatController.swift
//  Ollama Swift
//
//  Created by Karim ElGhandour on 08.10.23.
//

import Foundation

func sendPrompt(prompt: promptModel) async throws -> [responseModel]{
    print("Sending request")
    let endpoint = "http://192.168.0.107:11434/api/generate"
    
    guard let url = URL(string: endpoint) else {
        throw NetError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    request.httpBody = try encoder.encode(prompt)
            
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        print("Invalid response")
        throw NetError.invalidResponse
    }
    do {
        let json = try JSONParser.JSONObjectsWithData(data: data)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode([responseModel].self, from: json)
        return decoded
    } catch {
        print(error)
        throw NetError.invalidData
    }
}