//
//  UIImageView.swift
//  VkClient
//
//  Created by Alexander Fomin on 23.01.2021.
//

import UIKit

extension UIImageView {
    func download(from url: URL, closure: @escaping (URL) -> (Bool)) {

        let activityView = UIActivityIndicatorView(style: .medium)
        self.addSubview(activityView)
        activityView.frame = self.bounds
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.startAnimating()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                if closure(url) {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    self.image = image
                }
            }
        }.resume()
    }
    func download(from link: String, closure: @escaping (URL) -> (Bool)) {
        guard let url = URL(string: link) else { return }
        download(from: url, closure: closure)
    }
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
