//
//  CustomAnnotaionView.swift
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
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .orange
        label.textAlignment = .center
        return label
    }()
    
    lazy var customImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var stacView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, customImageView])
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(stacView)
        
        backgroundView.snp.makeConstraints {
            $0.width.height.equalTo(70)
        }
        
        stacView.snp.makeConstraints {
            $0.edges.equalTo(backgroundView).inset(5)
        }
    }
    
    // Annotation도 재사용을 하므로 재사용 전 값을 초기화 시켜서 다른 값이 들어가는 것을 방지
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
        titleLabel.text = nil
    }
    
    // 이 메서드는 annotation이 뷰에서 표시되기 전에 호출됩니다.
    // 즉, 뷰에 들어갈 값을 미리 설정할 수 있습니다
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? SSAnnotation else { return }
        titleLabel.text = annotation.title
        
        guard let image = annotation.image else { return }
        customImageView.image = image
    }
}
