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

extension CoordinatorDelegate {
    func didFinish(childCoordinator: Coordinator) { }
}

protocol Coordinator: AnyObject {
    
    var delegate: CoordinatorDelegate? { get set }
    var navigationController: UINavigationController { get set }
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
        navigationController.popViewController(animated: true)
    }
    
    func dismissViewController() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - SetNavigationBar

extension Coordinator {
    //투명 네비게이션 바
    func setClearNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setNavigationBarHidden(_ isHidden: Bool) {
        navigationController.isNavigationBarHidden = isHidden
    }
}

// MARK: - Auth

extension Coordinator {
    
    func moveToUserSetting() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: "아이폰의 위치 설정이 비활성화되어 있어요",
                                          message:
                                            "활성화로 설정을 바꿔주세요",
                                          preferredStyle: .alert)
            alert.view.tintColor = .label
            
            let primaryButton = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }
            
            alert.addAction(primaryButton)
            navigationController.present(alert, animated: true)
        }
    }
    
    func showToast(_ type: Toast,
                   font: UIFont = UIFont.systemFont(ofSize: 14.0),
                   completion: (() -> Void)? = nil) {
        guard let view = self.navigationController.visibleViewController?.view else { return }
        let messageLabel = PaddingLabel().then {
            $0.font = SSFont.semiBold16
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
            make.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1, delay: 1.0, options: .curveEaseOut, animations: {
            messageLabel.alpha = 0.0
        }, completion: { isCompleted in
            guard isCompleted == true else { return }
            messageLabel.removeFromSuperview()
            completion?()
        })
    }
}

// MARK: - Alert

extension Coordinator {
    
    func showAlert(type: UIAlertController.Style = .alert, title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: type)
        alert.view.tintColor = .tintColor
        
        let defaultButton = UIAlertAction(title: "확인", style: .default) { _ in
            action()
        }
        
        let cancleButton = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancleButton)
        alert.addAction(defaultButton)
        
        navigationController.present(alert, animated: true)
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
