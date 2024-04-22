//
//  ImageScrollView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/22/24.
//

import UIKit

import SnapKit

final class ImageScrollView: BaseView {
    
    var imageViews: [UIImageView] = [] {
        didSet {
            setupImageViews()
        }
    }
    
    private let pageControl = UIPageControl().then {
        $0.backgroundColor = .systemGray
        $0.alpha = 0.8
        $0.currentPage = 0
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.delegate = self
        $0.contentSize = CGSize(width: CGFloat(imageViews.count) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let totalWidth = CGFloat(imageViews.count) * scrollView.frame.width
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.frame.height)
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        }
    }
    
    private func setupImageViews() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.width)
        imageViews.forEach { scrollView.addSubview($0) }
        pageControl.numberOfPages = imageViews.count
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubviews(scrollView, pageControl)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        scrollView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
