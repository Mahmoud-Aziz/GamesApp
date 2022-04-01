//
//  RequestBuilder.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

class RequestBuilder {
    private var baseURL: URL?
    private var endpoint: String?
    private var method: HTTPMethod = .get
    private var headers: [String: String] = ["Content-Type": "application/json"]
    private var parameters: [String: String] = [:]
    private var httpBodyParams: Data?
    // TODO: after finish setup for base url and config file
     
    func setBaseUrl(_ string: String) {
        baseURL = URL(string: string) ?? URL(string: "")
    }
    func setEndpoint(_ value: String) {
        endpoint = value
    }
    func setMethod(_ value: HTTPMethod) {
        method = value
    }
    func setHeader(_ key: String, _ value: String) {
        headers[key] = value
    }
    func setQueryParameters(_ key: String, _ value: String) {
        parameters[key] = value
    }
    func setBodyParameters<T: Encodable>(_ body: T) {
        var httpBody: Data?
        do {
            let httpbodyData = try JSONSerialization.data(withJSONObject: body.toDictionary(), options: [])
            httpBody = httpbodyData } catch {
            //TODO: Log, after adding logging utility
        }
        httpBodyParams = httpBody
    }
    func build() -> URLRequest {
        guard let endpoint = endpoint, let baseURL = baseURL else {
            //TODO: REFACTOR
            return URLRequest(url: URL(string: "")!)
        }
        let url = baseURL.appendingPathComponent(endpoint)
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        var urlRequest = URLRequest(url: components!.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBodyParams
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }
}
