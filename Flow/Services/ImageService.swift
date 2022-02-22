//
//  ImageService.swift
//  Flow
//
//  Created by Hanna Chen on 2022/2/22.
//

import FirebaseStorage

enum ImageService {
    static func upload(image: UIImage?, completion: @escaping(_ profileImageURL: URL?, Error?) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let imageRef = Storage.storage().reference(withPath: "/profile-images/\(filename).jpeg")
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
