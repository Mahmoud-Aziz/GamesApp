//
//  DataProvider.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

typealias DetailsResultHandler = Result<DetailsResponse, Error>
typealias DetailsReponseHandler = (DetailsResultHandler) -> Void

class DetailsDataProvider: DetailsUseCase {
    
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func getDetails(completion: @escaping DetailsReponseHandler) {
        let requestBuilder = RequestBuilder()
        requestBuilder.setBaseUrl(APIBaseURL.baseURL)
        requestBuilder.setEndpoint(APIEndpoint.deetailsPath(id: id))
        requestBuilder.setMethod(.get)
        requestBuilder.setQueryParameters("page_size", "10")
        requestBuilder.setQueryParameters("key", APIKey.apiKey)
        requestBuilder.setQueryParameters("page", "1")
        let request = requestBuilder.build()
        APIService.shared.request(decodable: DetailsResponse.self, request: request, completion: { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                // Since this coming from previous layer, it should be already logged.
                completion(.failure(error))
            }
        })
    }
}
