//
//  GamesDataProvider.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation
typealias GamesResultHandler = Result<GamesResponse, Error>
typealias GamesReponseHandler = (GamesResultHandler) -> Void

class GamesDataProvider: GamesUseCase {
    func getGames(page: String, completion: @escaping GamesReponseHandler) {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(APIBaseURL.baseURL)
        requestBuilder.setEndpoint(APIEndpoint.games.rawValue)
        requestBuilder.setMethod(.get)
        requestBuilder.setQueryParameters("page_size", "10")
        requestBuilder.setQueryParameters("key", APIKey.apiKey)
        requestBuilder.setQueryParameters("page", page)
        let request = requestBuilder.build()
        APIService.shared.request(decodable: GamesResponse.self, request: request, completion: { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                // Since this coming from previous layer, it should be already logged.
                completion(.failure(error))
            }
        })
    }
    
    func search(for game: String, page: String, completion: @escaping GamesReponseHandler) {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(APIBaseURL.baseURL)
        requestBuilder.setEndpoint(APIEndpoint.games.rawValue)
        requestBuilder.setMethod(.get)
        requestBuilder.setQueryParameters("page_size", "10")
        requestBuilder.setQueryParameters("key", APIKey.apiKey)
        requestBuilder.setQueryParameters("page", page)
        requestBuilder.setQueryParameters("search", "\(game)")
        let request = requestBuilder.build()
        
        APIService.shared.request(decodable: GamesResponse.self, request: request, completion: { result in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
