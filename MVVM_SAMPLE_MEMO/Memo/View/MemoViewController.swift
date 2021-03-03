//
//  MemoViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/01/26.
//

import UIKit

class MemoViewController: UIViewController {
	@IBOutlet weak var memoTextView: UITextView!

	var viewModel: MemoViewModel?

	override func viewDidLoad() {
		super.viewDidLoad()
		memoTextView.delegate = self
		memoTextView.becomeFirstResponder()
		configureUI()
		configureCoreData()
	}

	private func configureUI() {
		viewModel?.memoModel.bind(listener: { [weak self] memoModel in
			self?.memoTextView.text = memoModel.content
		})
	}

	private func configureCoreData() {
		guard let viewModel = viewModel else { return }
		let currentIndex = viewModel.memoModel.value.index
		if viewModel.isUpdate {	// 기존 메모를 업데이트
			viewModel.changeIndexToTemp()	// 임시로 메모 entity index -1로 변경
			for index in (0..<viewModel.count).reversed() where index < currentIndex {
				viewModel.ascendIndex(of: index)
			}
		} else {	// 메모를 신규 생성하는 경우
			viewModel.memoContentInsert(content: "")	// 미리 메모 entity 생성(index: -1)
			for index in (0..<viewModel.count).reversed() {
				viewModel.ascendIndex(of: index)
			}
		}
		viewModel.changeIndexToFirst()	// -1로 변경한 index를 0으로 다시 변경
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.isMovingFromParent, let viewModel = viewModel {
			if memoTextView.text.count == 0 {			// 입력이 없음
				viewModel.memoContentDelete()			// index 0의 데이터 제거
				for index in (1..<viewModel.count) {	// index 조정
					viewModel.descendIndex(of: index)
				}
			}
		}
	}
}

extension MemoViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		viewModel?.memoContentUpdate(content: memoTextView.text)
	}
}
