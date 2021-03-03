//
//  MemoViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/01/27.
//

import UIKit

protocol MemoViewModelProtocol {
	func memoContentInsert(content: String)
	func memoContentUpdate(content: String)
}

class MemoViewModel: MemoViewModelProtocol {
	var isUpdate: Bool = false
	var memoModel: Dynamic<MemoModel> = .init(.init())
	var count: Int = 0

	init(isUpdate: Bool, count: Int, memoModel: MemoModel) {
		self.isUpdate = isUpdate
		self.count = count
		self.memoModel.value = memoModel
	}

	func memoContentInsert(content: String) {
		memoModel.value.date = Date()
		CoreDataManager.sharedManager.insertInCoreData(memoModel: memoModel.value)
	}

	func memoContentUpdate(content: String) {
		let title = content.split(separator: "\n", maxSplits: 1).map(String.init)
		if title.count == 0 { return }
		memoModel.value.homeTitle = title[0]
		memoModel.value.homeContent = (title.count > 1) ? title[1] : "추가 텍스트 없음"
		memoModel.value.content = content
		memoModel.value.date = Date()
		CoreDataManager.sharedManager.updateInCoreData(memoModel: memoModel.value)
	}

	func memoContentDelete() {
		CoreDataManager.sharedManager.deleteCoreData()
	}

	func changeIndexToTemp() {
		CoreDataManager.sharedManager.setTempIndexCoreData(memoModel: memoModel.value)
	}

	func ascendIndex(of index: Int) {
		CoreDataManager.sharedManager.ascendIndexCoreData(change: index)
	}

	func descendIndex(of index: Int) {
		CoreDataManager.sharedManager.descendIndexCoreData(change: index)
	}

	func changeIndexToFirst() {
		CoreDataManager.sharedManager.setFirstIndexCoreData()
	}
}
