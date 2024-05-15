//
//  ViewModelProtocol.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import Foundation

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    func transform(_ input: Input) -> Output
}
