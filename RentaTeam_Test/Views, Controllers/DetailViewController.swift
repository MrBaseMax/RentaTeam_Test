//
//  DetailViewController.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 20.02.2022.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cacheLabel: UILabel!
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Подробно"
        cacheLabel.isHidden = true
        
        imageView.sd_setLoadingIndicator()
        imageView.sd_setImage(with: imageURL) { image, error, cacheType, url in
            DispatchQueue.main.async {
                if image == nil {
                    self.imageView.image = UIImage(named: "simon")
                    
                } else {
                    switch cacheType {
                    case .memory, .disk:
                        
                        if let url = url,
                           let fileURLString = SDImageCache.shared.cachePath(forKey: url.absoluteString),
                           let fileURL = URL(string: fileURLString){
                            
                            do {
                                let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                                let fileCreateDate = attr[FileAttributeKey.modificationDate] as? Date
                                
                                if let fileCreateDate = fileCreateDate {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                                    let dateFormatted = dateFormatter.string(from: fileCreateDate)
                                    
                                    self.cacheLabel.isHidden = false
                                    self.cacheLabel.text = "Дата скачивания: \(dateFormatted)"
                                }
                            } catch {
                                print(error)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}
