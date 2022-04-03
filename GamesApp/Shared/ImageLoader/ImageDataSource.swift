//
//  ImageDataSource.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

public typealias ImageDataResponse = ((Result<Data, Error>) -> Void)

public protocol ImageDataSource {
    func load(_ url: URL, completion: ImageDataResponse?)
}

public struct RemoteImageDataSource: ImageDataSource {
    let urlSession: URLSession
    
    public init(_ session: URLSession) {
        self.urlSession = session
    }
    
    public func load(_ url: URL, completion: ImageDataResponse?) {
        let dataTask = urlSession.dataTask(with: url) {data, urlResponse, error in
            DispatchQueue.main.async {
                completion?(handleDataTaskResponse(data: data, urlResponse: urlResponse, error: error))
            }
        }
        dataTask.resume()
    }
    
    private func handleDataTaskResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let data = data {
            return .success(data)
        } else if let error = error {
            return .failure(error)
        }
        return .failure(ImageLoaderError.unknown)
    }
}
