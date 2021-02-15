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
		configureUI()
	}

	private func configureUI() {
		viewModel?.memoModel.bind(listener: { [weak self] memoModel in
			self?.memoTextView.text = memoModel.content
		})
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.isMovingFromParent, let homeViewController = self.navigationController?.topViewController as? HomeViewController, let viewModel = viewModel {
			(viewModel.isUpdate.value) ? viewModel.memoContentUpdate(content: memoTextView.text) : viewModel.memoContentInsert(content: memoTextView.text)
			homeViewController.viewModel?.memoListUpdate(memoViewModel: viewModel)
		}
	}
}
