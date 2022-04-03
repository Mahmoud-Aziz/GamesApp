//
//  APIServiceProtocol.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

protocol APIServiceProtocol {
    func request<T:Decodable>(decodable: T.Type, request: URLRequest, completion: NetworkResponse<T>?)
}
