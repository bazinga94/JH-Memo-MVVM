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
		if viewModel!.isUpdate.value {
			viewModel?.memoContentInsert(content: "")
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
			if !viewModel.isUpdate.value, memoTextView.text.count == 0 {		// new
				viewModel.memoContentDelete()
			} else if viewModel.isUpdate.value, memoTextView.text.count == 0 {	// edit
				viewModel.memoContentDelete()
//				homeViewController.viewModel?.memoListDelete(memoViewModel: viewModel)
			} else {
				homeViewController.viewModel?.memoListUpdate(memoViewModel: viewModel)
			}
		}
	}
}

extension MemoViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		viewModel?.memoContentUpdate(content: memoTextView.text)
	}
}
