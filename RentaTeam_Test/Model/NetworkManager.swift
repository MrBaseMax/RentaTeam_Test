//
//  NetworkManager.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 20.02.2022.
//

import Foundation

protocol NetworkManagerDelegate{
    func handleData(_ networkManager: NetworkManager, _ data: PicturesDataBatch)
	func handleError(_ error: Error?)
}


struct NetworkManager {
    
	var delegate: NetworkManagerDelegate?

    
    private func urlString(for pageNumber: Int) -> String {
        return "https://pixabay.com/api/?key=25766099-5e7b65a66d03195ee13c829d2&q=landscape&orientation=vertical&image_type=photo&page=\(pageNumber)&per_page=\(K.batchSize)"
        // ключ бы следовало спрятать, но этот не жалко
    }
    
    //запрос очередной страницы картинок
    func fetchBatch(_ batchNumber: Int) {
        if let url = URL(string: urlString(for: batchNumber)) {
			let session = URLSession(configuration: .default)
		
			let task = session.dataTask(with: url) { data, response, error in
				guard error == nil else { delegate?.handleError(error!); return }
				
				if let data = data {
					if let picturesData = self.parseJSON(data: data) {
						delegate?.handleData(self, picturesData)
					}
				} else {
					delegate?.handleError(nil)
				}
			}
			
			task.resume()
		}
	}
	 
	private func parseJSON(data: Data) -> PicturesDataBatch? {
		let decoder = JSONDecoder()
		
		do {
			return try decoder.decode(PicturesDataBatch.self, from: data)
		} catch {
			delegate?.handleError(error)
			return nil
		}
	}
}
