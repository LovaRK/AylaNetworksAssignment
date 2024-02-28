//
//  Extentions.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 28/02/24.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, defaultImageName: String = "defaultImage") {
        self.image = UIImage(named: defaultImageName)

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let downloadedImage = UIImage(data: data), error == nil {
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}


extension UIWindow {
    var isKeyAndVisible: Bool {
        return self.isKeyWindow && self.isHidden == false
    }
}
