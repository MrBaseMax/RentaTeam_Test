//
//  UIImageView_Extension.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 21.02.2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func sd_setLoadingIndicator() {
        if self.traitCollection.userInterfaceStyle == .dark {
            sd_imageIndicator = SDWebImageActivityIndicator.white
        } else {
            sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
    }
}
