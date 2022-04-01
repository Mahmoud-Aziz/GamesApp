//
//  ImageDownloader.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

public class ImageDownloader {
    private var cache = [String: Data]()
    private let source: ImageDataSource
    
    public init(source: ImageDataSource = RemoteImageDataSource(.shared)) {
        self.source = source
    }
    
    public func loadImageData(url: URL, completion: ImageDataResponse?) {
        // if image exists in the cache, return it, else make the call.
        if loadFromCache(url, completion: completion) != nil {
            return
        } else {
            source.load(url) {[weak self] result in
                completion?(result)
                switch result {
                case .success(let data):
                    self?.storeToCache(url.absoluteString, data)
                default:
                    break
                }
            }
        }
    }

    private func loadFromCache(_ url: URL) -> Data? {
        cache[url.absoluteString]
    }

    private func storeToCache(_ url: String, _ data: Data) {
        cache[url] = data
    }

    private func loadFromCache(_ url: URL, completion: ImageDataResponse?) -> Data? {
        guard let data = loadFromCache(url) else {
            completion?(.failure(ImageLoaderError.notFound))
            return nil
        }
        completion?(.success(data))
        return data
    }
}
