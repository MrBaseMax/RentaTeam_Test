//
//  PicturesDataPage.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 21.02.2022.
//

import Foundation

struct PicturesDataBatch: Decodable {
    var hits: [PictureData]
}

struct PictureData: Decodable {
    let id: Int
    let previewURL: String
    let largeImageURL: String
}
 
