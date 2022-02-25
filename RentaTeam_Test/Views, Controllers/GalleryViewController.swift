//
//  GalleryViewController.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 20.02.2022.
//

import UIKit
import SDWebImage

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: ModelProtocol = Model()
    var pictureSelected = 0
    var cellSize: CGSize {
        let sideSize = collectionView.bounds.width/CGFloat(K.columnsCount)
        return CGSize(width: sideSize, height: sideSize)
    }
    
    
    //MARK: - Методы
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Галерея"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        galleryInit()
    }
    
    func galleryInit() {
        fetchNextBatch()
        
        // чистка кэша данных о картинках от сервера
        //      URLCache.shared.removeAllCachedResponses()
        
        // чистка кэша самих картинок
        //      SDImageCache.shared.clearMemory()
        //      SDImageCache.shared.clearDisk()
        
        // (можно повесить на какую-нибудь кнопку или жест как pull-to-refresh)
    }
    
    func fetchNextBatch() {
        //асинхронная загрузка новой пачки картинок
        DispatchQueue.global(qos: .background).async {
            self.model.fetchNextBatch { result in
                DispatchQueue.main.async {
                    switch result {
                    case .ok:
                        self.collectionView.reloadData()
                        
                    case .fail(let error):
                        // в конце "online" галереи сервер возвращает кривой JSON, и падаем на декодировании
                        // в конце "offline" галереи попадаем на ошибку сети в замыкании метода URLSession.dataTask()
                        // оба сообщения в виде pop-up раздражают, поэтому просто вытащу в консоль
                        
                        let errorText = (error == nil) ? "Неизвестная ошибка" : String(describing: error)
                        print(errorText)
                        
                        // let alert = UIAlertController(title: "Ошибка", message: errorText, preferredStyle: .alert)
                        // alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                        // self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y //смещение верхнего края экрана
        let contentHeight = scrollView.contentSize.height //общая высота контента
        let frameHeight = scrollView.frame.height //высота рамки экрана
        
        //        если смещение пытается сдвинуть экран за границу контента, запрашиваем новый контент
        if offsetY > contentHeight - frameHeight - cellSize.height * CGFloat(K.cellsLeftToStartFetching) {
            if !model.isLoading() {
                
                fetchNextBatch()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else { return }
        guard let pictureData = model.pictureData(of: pictureSelected) else { return }
        
        vc.imageURL = URL(string: pictureData.largeImageURL)
    }
}


//MARK: - Вёрстка (UICollectionViewDelegateFlowLayout)
extension GalleryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
}


//MARK: - Заполнение данными (UICollectionViewDataSource)
extension GalleryViewController: UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.picturesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellID, for: indexPath) as! GalleryViewCell
        
        guard let pictureData = model.pictureData(of: indexPath.item),
              let url = URL(string: pictureData.previewURL) else { return cell }
        
        cell.imageView.sd_setLoadingIndicator()
        cell.imageView.sd_setImage(with: url) { image, error, cahceType, url in
            guard let image = image,
                  let size = image.getMetaDataFileSize() else { return }
            cell.label.text = "\(size) Байт"
        }
        
        return cell
    }
}


//MARK: - Поведение (UICollectionViewDelegate)
extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pictureSelected = indexPath.item
        performSegue(withIdentifier: K.segueID, sender: self)
    }
}
