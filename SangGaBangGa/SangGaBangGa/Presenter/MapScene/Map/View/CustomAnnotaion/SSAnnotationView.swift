//
//  SSAnnotationView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import MapKit
import UIKit

import MarqueeLabel
import Kingfisher

final class SSAnnotationView: MKAnnotationView {
    
    static var identifier: String {
        self.description()
    }
    
    private let shadowView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowColor = UIColor.systemGray.cgColor
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 4
        $0.clipsToBounds = false
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.font = SSFont.medium11
        $0.textColor = .accent
        $0.textAlignment = .center
    }
    
    let priceLabel = MarqueeLabel().then {
        $0.font = SSFont.light11
        $0.textColor = .label
        $0.type = .leftRight
        $0.animationCurve = .easeInOut
        $0.trailingBuffer = 4
        $0.speed = .duration(4)
    }
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, imageView, priceLabel])
        view.spacing = 2
        view.distribution = .fill
        view.axis = .vertical
        
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width).multipliedBy(0.8)
        }
        
        return view
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(shadowView)
        shadowView.addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        
        shadowView.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(84)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(84)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        priceLabel.text = nil
        imageView.image = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let annotation = annotation as? SSAnnotation else { return }
        titleLabel.text = annotation.title
        priceLabel.text = annotation.subtitle
        imageView.kf.setSeSACImage(input: APIKey.baseURL + "/v1/" + (annotation.data.files.first ?? ""))
        setNeedsLayout()
    }
}
