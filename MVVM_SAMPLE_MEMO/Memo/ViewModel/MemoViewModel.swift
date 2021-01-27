//
//  MemoViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/27.
//

import UIKit
import CoreData

protocol MemoViewModelProtocol {
//	var memoTitle: String! { get }
	var memoContent: String! { get }
//	var memoTitleDidChange: ((MemoViewModelProtocol) -> ())? { get set }
	var memoContentDidChange: ((MemoViewModelProtocol) -> ())? { get set }
	func refreshMemoView()
}

class MemoViewModel: MemoViewModelProtocol {
	var memoModel: MemoModel
//	var memoTitleDidChange: ((MemoViewModelProtocol) -> ())?
	var memoContentDidChange: ((MemoViewModelProtocol) -> ())?
	var index: Int
//	var memoTitle: String! {
//		didSet {
//			self.memoTitleDidChange?(self)
//		}
//	}
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
//		memoTitle = memoModel.title
		memoContent = memoModel.content
	}

	func memoContentUpdate(content: String) {
		let title = content.split(separator: "\n", maxSplits: 1).map(String.init)
		memoModel.homeTitle = title[0]
		memoModel.homeContent = (title.count > 1) ? title[1] : "추가 텍스트 없음"
		memoModel.content = content
		saveInCoreData(memoModel: memoModel)
	}

	private func saveInCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "MemoEntity", in: context)

		let content = NSManagedObject(entity: entity!, insertInto: context)
		content.setValue(memoModel.content, forKey: "content")
		content.setValue(memoModel.homeTitle, forKey: "homeTitle")
		content.setValue(memoModel.homeContent, forKey: "homeContent")

		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
	}
}
