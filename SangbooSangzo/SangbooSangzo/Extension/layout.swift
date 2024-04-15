//
//  ViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

//import UIKit
//
//import RxCocoa
//import RxSwift
//import PinLayout
//import FlexLayout
//
//class ViewController: RxBaseViewController {
//    
//    private let rootFlexContainer = UIView().then {
//        $0.backgroundColor = .red
//    }
//    
//    private let view1 = UIView().then {
//        $0.backgroundColor = .red
//    }
//    
//    private let view2 = UIView().then {
//        $0.backgroundColor = .blue
//    }
//    
//    private let label1 = UILabel().then {
//        $0.backgroundColor = .green
//        $0.textColor = .white
//        $0.text = "top(_ offset: CGFloat)/ top(_ offset: Percent)/ top()/ 위쪽 가장자리를 배치합니다. 오프셋은 슈퍼뷰 상단 가장자리로부터 상단 가장자리 거리를 픽셀 단위(또는 슈퍼뷰 높이의 백분율)로 지정합니다. 호출과 유사하며 뷰 상단 가장자리를 수퍼뷰 상단 가장자리에 직접 배치합니다. 이 속성을 사용하면 safeArea, 읽기 가능 및 레이아웃 여백 에 특히 유용합니다 .top(_ margin: UIEdgeInsets)"
//        $0.numberOfLines = 0
//    }
//    
//    private let separatorView = UIView().then {
//        $0.backgroundColor = .lightGray
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//    }
//    
//    override func configureHierarchy() {
//        super.configureHierarchy()
//        view.addSubviews(rootFlexContainer)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        rootFlexContainer.pin.top().left().width(100%)
//        rootFlexContainer.flex.layout(mode: .adjustHeight)
//        
//        rootFlexContainer.flex.direction(.column).padding(12).define { flex in
//            flex.addItem().direction(.row).define { flex in
//                flex.addItem(view1).size(100)
//                
//                flex.addItem().direction(.row).paddingLeft(12).grow(1).define { flex in
//                    flex.addItem(view2).marginRight(12).grow(1)
//                }
//            }
//        }
//        
////        print("1")
////        view1.pin
////            .top(view.pin.safeArea)
////            .left(view.pin.safeArea)
////            .size(100)
////            .margin(10)
////        view2.pin
////            .after(of: view1, aligned: .top)
////            .right(view.pin.safeArea.right)
////            .height(100)
////            .marginHorizontal(10)
////        label1.pin
////            .below(of: view1)
////            .width(of: view)
////            .hCenter()
////            .height(50%)
////            .sizeToFit(.heightFlexible)
////            .marginTop(10)
////        separatorView.pin
////            .below(of: label1)
////            .width(90%)
////            .height(1)
////            .hCenter()
////            .margin(10)
//    }
//    
//    override func configureLayout() {
//        super.configureLayout()
//
//    }
//    
//    override func configureView() {
//        super.configureView()
//        navigationItem.title = "ㅎㅇ"
//    }
//}

