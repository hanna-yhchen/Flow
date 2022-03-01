//
//  ImageService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/22.
//

import FirebaseStorage

enum ImageService {
    enum StorageCollection {
        case profileImages
        case postImages
    }
    static func upload(image: UIImage?, to collection: StorageCollection, completion: @escaping(_ imageURL: URL?, Error?) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString

        var rootPath = ""
        switch collection {
        case .profileImages:
            rootPath = "/profile-images/"
        case .postImages:
            rootPath = "/post-images/"
        }
        let imageRef = Storage.storage().reference(withPath: rootPath + filename + ".jpeg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            imageRef.downloadURL { url, error in
                completion(url, error)
            }
        }
    }
}
