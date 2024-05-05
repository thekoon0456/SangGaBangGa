//
//  Then+.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

// MARK: - PortOne 내부 Then 으로 대체

//import Foundation
//import UIKit
//import Then
//
//protocol Then {}
//
//extension Then where Self: AnyObject {
//    func then(_ block: (Self) -> Void) -> Self {
//        block(self)
//        return self
//    }
//}
//
//extension Then where Self: Any {
//    func then(_ block: (inout Self) -> Void) -> Self {
//        var copy = self
//        block(&copy)
//        return copy
//    }
//}
//
//extension NSObject: Then {}
//
//extension Array: Then {}
//extension Dictionary: Then {}
//extension Set: Then {}
//extension UIButton.Configuration: Then {}
//extension UIListContentConfiguration: Then {}
//extension UICollectionLayoutListConfiguration: Then {}
//extension UIBackgroundConfiguration: Then {}
//extension NSDiffableDataSourceSnapshot: Then {}
