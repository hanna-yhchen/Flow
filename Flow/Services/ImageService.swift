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

    static func upload(image: UIImage?, to collection: StorageCollection, completion: @escaping(_ imageURL: String) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.6) else { return }
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
            if let error = error {
                print("DEBUG: Error updating image to storage -", error.localizedDescription)
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("DEBUG: Error downloading image url -", error.localizedDescription)
                    return
                }

                if let imageURL = url?.absoluteString {
                    completion(imageURL)
                }
            }

             // let url = "https://storage.googleapis.com/flow-807ea.appspot.com/" + imageRef.fullPath
             // completion(url)
        }
    }
}
