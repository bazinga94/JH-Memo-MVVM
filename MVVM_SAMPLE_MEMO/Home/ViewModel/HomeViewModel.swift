//
//  HomeViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit

// YG 참고!
protocol ViewModel {
	associatedtype Model
	var model: Model { get set }
	init(model: Model)
	/// Data 갱신 처리 ( bind한 view에게 알림 )
	func configureOutput()
}

protocol HomeViewModelProtocol {
	func memoDidSelect(for index: Int) -> MemoViewModel
	func memoListUpdate(memoViewModel: MemoViewModel)
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
	var title: Dynamic<String> = .init("")
	var memoList: Dynamic<[MemoModel]> = .init(.init())

	override init() {
		super.init()
		configureModel()
	}

	private func configureModel() {
		title.value = "MVVM 메모앱"
		memoList.value = fetchFromCoreData()
	}

	func memoDidSelect(for index: Int) -> MemoViewModel {
		return MemoViewModel(isUpdate: true, index: index, memoModel: memoList.value[index])
	}

	func memoListUpdate(memoViewModel: MemoViewModel) {
		if memoList.value.count > 0, memoViewModel.isUpdate.value {
			memoList.value.remove(at: memoViewModel.index.value)
		}
		memoList.value.insert(memoViewModel.memoModel.value, at: 0)
	}

	func memoListDelete(memoViewModel: MemoViewModel) {
		if memoList.value.count > 0 {
			memoList.value.remove(at: memoViewModel.index.value)
		}
	}

	private func fetchFromCoreData() -> [MemoModel] {
		var memoModelList: [MemoModel] = []
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		do {
			let memoEntityList = try context.fetch(MemoEntity.fetchRequest()) as! [MemoEntity]
			memoEntityList.forEach { (entity) in
				var memoModel = MemoModel()
				memoModel.homeTitle = entity.homeTitle!
				memoModel.homeContent = entity.homeContent!
				memoModel.content = entity.content!
				memoModel.date = entity.date!
				memoModel.index	= entity.index
				memoModelList.append(memoModel)
			}
			return memoModelList
		} catch {
			print(error.localizedDescription)
			return []
		}
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
