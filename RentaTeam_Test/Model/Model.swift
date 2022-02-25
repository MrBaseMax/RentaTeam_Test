//
//  Model.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 21.02.2022.
//

import Foundation

enum Result {
    case ok
    case fail(_ error: Error?)
}

protocol ModelProtocol {
    func isLoading() -> Bool
    func fetchNextBatch(_ completion: ((_ result: Result) -> Void )?)
    func pictureData(of index: Int) -> PictureData?
    func picturesCount() -> Int
}

class Model {
    typealias PictureID = Int
    
    var completion: ((_ result: Result) -> Void)?
    var networkManager = NetworkManager()
    var pictures = [PictureData]()
    var loading = false
    var latestBatchNumber = 0
    
    init() {
        networkManager.delegate = self
    }
    
    func picturesCount() -> Int {
        return pictures.count
    }
}

extension Model: ModelProtocol {
    func pictureData(of index: Int) -> PictureData? {
        guard pictures.count > index else { return nil }
        return pictures[index]
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
    func fetchNextBatch(_ completion: ((_ result: Result) -> Void )?) {
        loading = true
        networkManager.fetchBatch(latestBatchNumber + 1)
        self.completion = completion
    }
    
}

extension Model: NetworkManagerDelegate {
    func handleData(_ networkManager: NetworkManager, _ data: PicturesDataBatch) {
        latestBatchNumber += 1
        pictures += data.hits
        
        loading = false
        if let completion = completion {
            completion(.ok)
        }
    }
    
    func handleError(_ error: Error?) {
        loading = false
        if let completion = completion {
            completion(.fail(error))
        }
    }
}
