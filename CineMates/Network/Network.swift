//
//  Network.swift
//  CineMates
//
//  Created by Marco Agizza on 13/05/23.
//

import Foundation

class Network<Item: Decodable>: NSObject {
    
    /// Create a urlSession object, use this to perform requests
    let session: URLSession = URLSession(configuration: .default)
    
    /// URLComponents, use this to create and manipulate endpoints
    var components = URLComponents()
    
    /// Decoder for JSON `Data`.
    lazy var decoder = JSONDecoder()
    
    /// Encoder for JSON `Data`.
    lazy var encoder = JSONEncoder()
    
    override init() {
        super.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    // MARK: Network operations
    
    /// This function allows you to retrieve a list of `Item` throw a network call
    ///
    /// - Parameters:
    ///   - scheme:
    ///   - host:
    ///   - path: the path of the request
    ///   - apiKey:
    ///   - queryItems: 
    func list(scheme: String, host: String, path: String, apiKey: String? = nil, queryItems: [URLQueryItem] = []) async throws -> Item? {
        
        let request = buildRequest(
            method: "GET",
            scheme: scheme,
            host: host,
            path: path,
            apiKey: apiKey,
            queryItems: queryItems
        )
        let data = try await perform(request: request)
        return try decoder.decode(Item.self, from: data)
    }
    
    // MARK: Network helpers
    
    /// This function allows you to be able to perform the request after executing it.
    ///
    /// This function is implemented in three different ways based on the patter design.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` that needs to be performed
    /// - Returns: The data received from the network call
    func perform(request: URLRequest?) async throws -> Data {
        guard let request else {
            throw NetworkError.badRequest
        }
        
        return try ResponseHandler.shared.mapResponse(await session.data(for: request))
    }
    
    
    /// This function allows you to be able to create the URLRequest object, which can be used to be able to make a network call
    ///
    /// - Parameters:
    ///   - method: The HTTP Method
    ///   - scheme:The protocol to be used to access the resource
    ///   - host:Identifies the host that holds the resource
    ///   - path: The path of the request
    ///   - apiKey: The Bearer Token useful for authentication of the request if needed.
    ///   - queryItems: The Query items of the request if needed.
    ///   - body: The body of the request if needed.
    func buildRequest(method: String,
                      scheme: String,
                      host: String,
                      path: String,
                      apiKey: String? = nil,
                      queryItems: [URLQueryItem]? = nil,
                      body: (any Codable)? = nil)
    -> URLRequest? {
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = []
        
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        if let apiKey {
            components.queryItems?.insert(URLQueryItem(name: "api_key", value: apiKey), at: 0)
        }
        guard let theURL = components.url else { return nil }
        var request = URLRequest(url: theURL)
        request.httpMethod = method
        
        if let body {
            do {
                request.httpBody = try encoder.encode(body) // asData(json: body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return nil
            }
        }
        
        return request
    }
}
