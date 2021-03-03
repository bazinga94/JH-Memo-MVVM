//
//  MemoViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit

class MemoViewController: UIViewController {
	@IBOutlet weak var memoTextView: UITextView!

	var viewModel: MemoViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()
		memoTextView.delegate = self
		configureUI()
		guard let viewModel = viewModel else { return }
		if viewModel.isUpdate {	// 기존 메모를 업데이트
			viewModel.setTempIndexCoreData(memoModel: viewModel.memoModel.value)	// 임시로 메모 entity index -1로 변경
		} else {	// 메모를 신규 생성하는 경우
			viewModel.memoContentInsert(content: "")	// 미리 메모 entity 생성(index: -1)
		}
	}

	private func configureUI() {
		viewModel?.memoModel.bind(listener: { [weak self] memoModel in
			self?.memoTextView.text = memoModel.content
		})
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.isMovingFromParent, let homeViewController = self.navigationController?.topViewController as? HomeViewController, let viewModel = viewModel {
			if memoTextView.text.count == 0 {		// 입력이 없음
				viewModel.memoContentDelete()
			} else {
				let currentIndex = viewModel.memoModel.value.index
				if viewModel.isUpdate {
					for index in (0..<viewModel.count).reversed() where index < currentIndex {
						viewModel.ascendIndexCoreData(change: index)
					}
				} else if viewModel.count > 0 {
					for index in (0..<viewModel.count).reversed() {
						viewModel.ascendIndexCoreData(change: index)
					}
				}
			}
			homeViewController.viewModel?.memoListUpdate(memoViewModel: viewModel)
		}
	}
}

extension MemoViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		viewModel?.memoContentUpdate(content: memoTextView.text)
	}
}
