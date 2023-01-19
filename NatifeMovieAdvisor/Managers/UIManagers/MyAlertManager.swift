//
//  MyAlertManager.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 11.01.2023.
//

import UIKit

struct MyAlertManager {
    static let shared: MyAlertManager = .init()
    private init() { }

    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let completion: () -> Void

        init(
            title: String,
            style: UIAlertAction.Style,
            completion: @escaping () -> Void = { }
        ) {
            self.title = title
            self.style = style
            self.completion = completion
        }
    }

    private func buildAlertView(
        preferredStyle: UIAlertController.Style = .alert,
        title: String?,
        message: String?,
        actions: [Action],
        dissmissAction: Action?
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        actions.forEach { action in
            alertController.addAction(.init(title: action.title, style: action.style) { _ in
                action.completion()
            })
        }

        if let dissmissAction = dissmissAction {
            alertController.addAction( .init(title: dissmissAction.title, style: dissmissAction.style) { _ in
                dissmissAction.completion()
            })
        }

        return alertController
    }

    func presentAlertWithOptions(
        title: String?,
        message: String?,
        actions: [Action],
        dismissActionTitle: Action?) -> UIAlertController {
            buildAlertView(title: title, message: message, actions: actions, dissmissAction: dismissActionTitle)
    }

    func presentTemporaryInfoAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        forTime: TimeInterval
    ) -> UIAlertController {
        let alertController: UIAlertController = .init(title: title,
                                                       message: message,
                                                       preferredStyle: preferredStyle
        )

        Timer.scheduledTimer(withTimeInterval: forTime,
                             repeats: false) {_ in
                alertController.dismiss(animated: true, completion: nil)
        }
        return alertController
    }

        // MARK: - Alert that shows different types of error (Bad network connection included)
        func showErrorAlert(_ message: String, controller: UIViewController) {
            let errorAlert = MyAlertManager.shared.presentTemporaryInfoAlert(
                title: Constants.AlertAnswers.somethingWentWrongAnswear,
                message: message,
                preferredStyle: .actionSheet,
                forTime: 8.0)
            DispatchQueue.main.async {
                controller.present(errorAlert, animated: true)
            }
        }
}
