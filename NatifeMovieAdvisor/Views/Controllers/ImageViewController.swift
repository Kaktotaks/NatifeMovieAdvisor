//
//  ImageViewController.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 17.01.2023.
//

import UIKit

final class ImageViewController: UIViewController {
    // MARK: - Constants and Variables
    private lazy var movieImage: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }

    init(movieImage: UIImageView) {
        super.init(nibName: nil, bundle: nil)

        self.movieImage.image = movieImage.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addGesture()
    }

    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        movieImage.frame = view.bounds
        view.addSubview(movieImage)
    }

    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(
            target: self,
            action: #selector(pinch(_:))
        )
        movieImage.addGestureRecognizer(pinchGesture)
        movieImage.isUserInteractionEnabled = true
    }

    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.movieImage.frame.size.width / self.movieImage.bounds.size.width
            let newScale = currentScale * sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.movieImage.transform = transform
            sender.scale = 1
        } else if sender.state == .ended {
            self.movieImage.transform = CGAffineTransform.identity
        }
    }
}
