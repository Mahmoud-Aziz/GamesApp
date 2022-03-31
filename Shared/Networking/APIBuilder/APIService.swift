//
//  APIService.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

typealias NetworkResponse<T> = (Result<T, Error>) -> Void

class APIService: APIServiceProtocol {
    private var task: URLSessionTask?
    static let shared = APIService()
    private lazy var session = URLSession.shared
    private var requests = [URLRequest: URLSessionTask]()

    private init() {}
    
    //MARK: - URLSession request
    func request<T:Decodable>(decodable: T.Type, request: URLRequest, completion: NetworkResponse<T>?) {
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                guard let data = data else {
                    self.handleErrorState(decodable: T.self, response: response, error: error, completion: completion)
                    return
                }
                self.parseJsonResults(decodable: T.self, data: data, completion: completion)
            }
        }
        requests[request] = task
        task?.resume()
    }
}

//MARK: - Handle error state
extension APIService {
    private func handleErrorState<T:Decodable>(decodable: T.Type, response: URLResponse?, error: Error?, completion: NetworkResponse<T>?) {
        if let error = error {
            //TODO: report to error logger tool.
        }
        return
    }
}

//MARK: - Parsing Response
extension APIService {
    private func parseJsonResults<T:Decodable>(decodable: T.Type, data: Data, completion: NetworkResponse<T>?) {
        do {
            let object = try JSONDecoder().decode(decodable.self, from: data)
            completion?(.success(object))
        }
        catch let error {
            //TODO: report to error logger tool.
     
            completion?(.failure(APIError.decodeFailure))
        }
    }
}
