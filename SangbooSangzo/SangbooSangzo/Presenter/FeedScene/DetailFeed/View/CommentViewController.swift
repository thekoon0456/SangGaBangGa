//
//  CommentViewController.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/2/24.
//

import UIKit

import RxCocoa
import RxSwift

final class CommentViewController: RxBaseViewController {
    
    private let viewModel: CommentViewModel
    
    private let commentTitle = UILabel().then {
        $0.text = "댓글"
        $0.font = SSFont.semiBold24
    }
    
    private let commentsTableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    private let commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        $0.leftViewMode = .always
    }
    
    private let sendButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
                    , for: .normal)
        $0.tintColor = .tintColor
    }
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        super.bind()
        let sendButtonTapped = sendButton.rx.tap.withLatestFrom(commentTextField.rx.text.orEmpty)
        
        let input = CommentViewModel.Input(sendButtonTapped: sendButtonTapped,
        cellDeleted: commentsTableView.rx.itemDeleted)
        let output = viewModel.transform(input)
        
        output
            .comments
            .drive(commentsTableView.rx.items(cellIdentifier: CommentCell.identifier,
                                              cellType: CommentCell.self)
            ) { row, element, cell in
                cell.configureCell(data: element)
            }
            .disposed(by: disposeBag)
        
        output
            .comments
            .drive(with: self) { owner, comments in
                owner.scrollToBottom()
            }
            .disposed(by: disposeBag)
        
        commentsTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubviews(commentTitle, commentsTableView, commentTextField, sendButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        commentTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(commentTitle.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-8)
            make.height.equalTo(40)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.top)
            make.leading.equalTo(commentTextField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(commentTextField.snp.bottom)
            make.width.equalTo(44)
        }
    }
    
    override func configureView() {
        super.configureView()
        sheetPresentationController?.prefersGrabberVisible = true
    }
}

extension CommentViewController {
    
    func scrollToBottom() {
        let rowCount = commentsTableView.numberOfRows(inSection: 0)
        if rowCount > 0 {
            let indexPath = IndexPath(row: rowCount - 1, section: 0)
            commentsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}


// MARK: - Comment Delete

extension CommentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let userID = UserDefaultsManager.shared.userData.userID else {
            return .none
        }
        let comment = viewModel.getCurrentComments()[indexPath.row]
        return comment.creator.userID == userID ? .delete : .none
    }
}
