//
//  SettingViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/23/24.
//

import UIKit

final class SettingViewController: RxBaseViewController {
    
    let viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
}
