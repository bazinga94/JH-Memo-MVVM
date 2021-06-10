//
//  HomeViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/01/26.
//

import UIKit

protocol ViewModel {
	associatedtype Model
	var model: Model { get set }
	init(model: Model)
	/// Data 갱신 처리 ( bind한 view에게 알림 )
	func configureOutput()
}

protocol HomeViewModelProtocol {
	func memoDidSelect(for index: Int) -> MemoViewModel
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
	var title: Dynamic<String> = .init("")
	var memoList: Dynamic<[MemoModel]> = .init(.init())

	override init() {
		super.init()
		configureModel()
	}

	func configureModel() {
		title.value = "MVVM 메모앱"
		memoList.value = CoreDataManager.sharedManager.fetchFromCoreData().sorted(by: { $0.index < $1.index })
		memoList.value.forEach({ print($0) })
	}

	func memoDidSelect(for index: Int) -> MemoViewModel {
		return MemoViewModel(isUpdate: true, count: memoList.value.count, memoModel: memoList.value[index])
	}
}

extension HomeViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memoList.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.titleLabel.text = memoList.value[indexPath.row].homeTitle
		cell.contentLabel.text = memoList.value[indexPath.row].homeContent
		cell.dateLabel.text = memoList.value[indexPath.row].date.dateToString("yyyy.MM.dd HH:mm:ss")
		return cell
	}
}
