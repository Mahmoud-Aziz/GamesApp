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
    func getGames(completion: @escaping GamesReponseHandler) {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(APIBaseURL.baseURL)
        requestBuilder.setEndpoint(APIEndpoint.games.rawValue)
        requestBuilder.setMethod(.get)
        requestBuilder.setQueryParameters("page_size", "10")
        requestBuilder.setQueryParameters("key", APIKey.apiKey)
        requestBuilder.setQueryParameters("page", "1")
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
    
    func search(for game: String, completion: @escaping GamesReponseHandler) {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(APIBaseURL.baseURL)
        requestBuilder.setEndpoint(APIEndpoint.games.rawValue)
        requestBuilder.setMethod(.get)
        requestBuilder.setQueryParameters("page_size", "10")
        requestBuilder.setQueryParameters("key", APIKey.apiKey)
        requestBuilder.setQueryParameters("page", "1")
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
