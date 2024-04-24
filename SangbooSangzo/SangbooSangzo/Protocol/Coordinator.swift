//
//  Coordinator.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//


import UIKit

protocol CoordinatorDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func popViewController()
    func dismissViewController()
    //    func presentErrorAlert(title: String?, message: String?, handler: (() -> Void)?)
}

extension Coordinator {
    
    func start() { }
    
    func finish() {
        childCoordinators.removeAll()
        delegate?.didFinish(childCoordinator: self)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController?.dismiss(animated: true)
    }
    
    //    func presentErrorAlert(
    //        title: String? = nil,
    //        message: String? = "에러 발생",
    //        handler: (() -> Void)? = nil
    //    ) {
    //        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //            .appendingAction(title: "확인", handler: handler)
    //
    //        navigationController?.present(alertController, animated: true)
    //    }
}

// MARK: - SetNavigation

//extension Coordinator {
//    //투명 네비게이션 바
//    func setClearNavigationBar() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.backgroundImage = UIImage()
//        appearance.shadowImage = UIImage()
//        appearance.backgroundColor = .clear
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    }
//}

// MARK: - Auth

extension Coordinator {
    
    //    func moveToUserSetting() {
    //        DispatchQueue.main.async { [weak self] in
    //            guard let self else { return }
    //            let alert = UIAlertController(title: "Access to Apple Music is required to use the app.",
    //                                          message:
    //                                            "Please allow permission in settings to access the music library.",
    //                                          preferredStyle: .alert)
    //            alert.view.tintColor = .label
    //
    //            let primaryButton = UIAlertAction(title: "Go to Settings", style: .default) { _ in
    //                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
    //                    return
    //                }
    //                if UIApplication.shared.canOpenURL(settingsUrl) {
    //                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
    //                }
    //            }
    //
    //            alert.addAction(primaryButton)
    //
    //            navigationController?.present(alert, animated: true)
    //        }
    //    }
    
    func presentLoginScene() {
        let coordinator = AuthCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showToast(_ type: Toast,
                   font: UIFont = UIFont.systemFont(ofSize: 14.0),
                   completion: (() -> Void)? = nil) {
        guard let view = self.navigationController?.visibleViewController?.view else { return }
        let messageLabel = PaddingLabel().then {
            $0.font = .boldSystemFont(ofSize: 20)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            $0.padding = .init(top: 12, left: 12, bottom: 12, right: 12)
            $0.backgroundColor = .tintColor
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.text = type.message
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-48)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseIn, animations: {
            messageLabel.alpha = 0.0
        }, completion: { isCompleted in
            guard isCompleted == true else { return }
            messageLabel.removeFromSuperview()
            completion?()
        })
    }
}


