//
//  MemoViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/27.
//

import UIKit

protocol MemoViewModelProtocol {
	var memoTitle: String! { get }
	var memoContent: String! { get }
	var memoTitleDidChange: ((MemoViewModelProtocol) -> ())? { get set }
	var memoContentDidChange: ((MemoViewModelProtocol) -> ())? { get set }
	func refreshMemoView()
}

class MemoViewModel: MemoViewModelProtocol {
	var memoModel: MemoModel
	var memoTitleDidChange: ((MemoViewModelProtocol) -> ())?
	var memoContentDidChange: ((MemoViewModelProtocol) -> ())?
	var index: Int
	var memoTitle: String! {
		didSet {
			self.memoTitleDidChange?(self)
		}
	}
	var memoContent: String! {
		didSet {
			self.memoContentDidChange?(self)
		}
	}

	init(index: Int, memoModel: MemoModel) {
		self.index = index
		self.memoModel = memoModel
	}

	func refreshMemoView() {
		memoTitle = memoModel.title
		memoContent = memoModel.content
	}

	func memoContentUpdate(content: String) {
		memoModel.content = content
	}
}
