//
//  NetworkManager.swift
//  FormSubmission
//
//  Created by Gursimran Kaur on 04/06/25.
//

import Foundation

struct FormData: Codable {
    let name: String
    let email: String
    let contactNumber: String
}

struct APIResponse: Codable {
    let message: String
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiURL = URL(string: "https://httpbin.org/post")!
    
    func submitForm(formData: FormData, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let url = URL(string: "https://httpbin.org/post") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(formData)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            print("Raw API response:", String(data: data, encoding: .utf8) ?? "Invalid data")
            
            do {
                let httpBinResponse = try JSONDecoder().decode(HTTPBinResponse.self, from: data)
                
                let response = APIResponse(message: "Form submitted successfully!")
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    private struct HTTPBinResponse: Codable {
        let json: FormData
    }
}
