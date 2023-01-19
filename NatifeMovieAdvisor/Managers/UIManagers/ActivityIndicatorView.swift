//
//  ActivityIndicatorView.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 10.01.2023.
//

import UIKit
import Lottie
import SnapKit

class ActivityIndicatorView: UIView {
    static var shared = ActivityIndicatorView()

    private let loadingAnimationView = LottieAnimationView()

    enum AnimationName: String {
        case movieLoading
    }

    // MARK: - Setup UI Components
    override func layoutSubviews() {
        super.layoutSubviews()

        setupView()
        setupAnimationView()
    }

    private func setupView() {
        self.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        self.frame = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
    }

    private func setupAnimationView() {
        self.addSubview(self.loadingAnimationView)
        loadingAnimationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(240)
        }
    }

    // MARK: - Methods
    func showIndicator(_ animationName: AnimationName) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            UIApplication.shared.windows.first?.addSubview(self)
            self.loadingAnimationView.animation = LottieAnimation.named(animationName.rawValue)
            self.loadingAnimationView.contentMode = .scaleAspectFit
            self.loadingAnimationView.loopMode = .loop
            self.loadingAnimationView.play()
            self.addSubview(self.loadingAnimationView)
        }
    }

    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stopAnimation()
        }
    }

    private func stopAnimation() {
        loadingAnimationView.stop()
        loadingAnimationView.removeFromSuperview()
        self.removeFromSuperview()
    }
}
