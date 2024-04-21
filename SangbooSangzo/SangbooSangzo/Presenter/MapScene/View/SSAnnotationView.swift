//
//  SSAnnotationView.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/15/24.
//

import MapKit
import UIKit

final class SSAnnotationView: MKAnnotationView {
    
    static var identifier: String {
        self.description()
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let titleLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    let priceLabel = UILabel().then {
        $0.font = SSFont.titleSmall
        $0.textColor = .label
        $0.textAlignment = .center
    }
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, priceLabel, imageView])
        view.spacing = 5
        view.axis = .vertical
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
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        
        backgroundView.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(100)
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
        guard let image = annotation.image else { return }
        imageView.image = image
    }
}
