//
//  MemoViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit

class MemoViewController: UIViewController {
	@IBOutlet weak var memoTextView: UITextView!

	var viewModel: MemoViewModel? {
		didSet {
//			viewModel?.memoTitleDidChange = { [weak self] viewModel in
//				self?.memoTextView.text = viewModel.memoTitle + viewModel.memoContent
//			}
			viewModel?.memoContentDidChange = { [weak self] viewModel in
				self?.memoTextView.text = viewModel.memoContent
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel?.refreshMemoView()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.isMovingFromParent, let homeViewController = self.navigationController?.topViewController as? HomeViewController, let viewModel = viewModel {
			viewModel.memoContentUpdate(content: memoTextView.text)
			homeViewController.viewModel?.memoListUpdate(memoViewModel: viewModel)
		}
	}
}
