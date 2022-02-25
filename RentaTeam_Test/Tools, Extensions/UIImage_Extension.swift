//
//  UIImage_Extension.swift
//  RentaTeam_Test
//
//  Created by Максим Шайков on 21.02.2022.
//

import UIKit

//Метаданные. Код нагуглил, для отображения выбрал размер файла (это единственное, что у картинок различается)
//Решение спорное, поэтому убираться здесь пока не буду

extension UIImage {
    func getMetaDataFileSize() -> Int? {
        guard let data = self.jpegData(compressionQuality: 1),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        
//        if let type = CGImageSourceGetType(source) {
//            print("type: \(type)")
//        }
        
        if let properties = CGImageSourceCopyProperties(source, nil) {
//            print("properties - \(properties)")
            
            if let dict = properties as? [String:Int],
               let size = dict["FileSize"]{
                return size
            }
            
        }

//        let count = CGImageSourceGetCount(source)
//        print("count: \(count)")

//        for index in 0..<count {
//            if let metaData = CGImageSourceCopyMetadataAtIndex(source, index, nil) {
//                print("all metaData[\(index)]: \(metaData)")
//
//                let typeId = CGImageMetadataGetTypeID()
//                print("metadata typeId[\(index)]: \(typeId)")
//
//
//                if let tags = CGImageMetadataCopyTags(metaData) as? [CGImageMetadataTag] {
//
//                    print("number of tags - \(tags.count)")
//
//                    for tag in tags {
//
//                        let tagType = CGImageMetadataTagGetTypeID()
//                        if let name = CGImageMetadataTagCopyName(tag) {
//                            print("name: \(name)")
//                        }
//                        if let value = CGImageMetadataTagCopyValue(tag) {
//                            print("value: \(value)")
//                        }
//                        if let prefix = CGImageMetadataTagCopyPrefix(tag) {
//                            print("prefix: \(prefix)")
//                        }
//                        if let namespace = CGImageMetadataTagCopyNamespace(tag) {
//                            print("namespace: \(namespace)")
//                        }
//                        if let qualifiers = CGImageMetadataTagCopyQualifiers(tag) {
//                            print("qualifiers: \(qualifiers)")
//                        }
//                        print("-------")
//                    }
//                }
//            }
//
//            if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) {
//                print("properties[\(index)]: \(properties)")
//            }
//        }
        return nil
    }
}
