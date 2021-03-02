//
//  MemoViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/27.
//

import UIKit
import CoreData

protocol MemoViewModelProtocol {
	func memoContentInsert(content: String)
	func memoContentUpdate(content: String)
}

class MemoViewModel: CoreDataCRUD, MemoViewModelProtocol {
	var isUpdate: Bool = false
	var memoModel: Dynamic<MemoModel> = .init(.init())
	var count: Int = 0

	init(isUpdate: Bool, count: Int, memoModel: MemoModel) {
		self.isUpdate = isUpdate
		self.count = count
		self.memoModel.value = memoModel
	}

	func memoContentInsert(content: String) {
		memoModel.value.homeTitle = ""
		memoModel.value.homeContent = ""
		memoModel.value.content = ""
		memoModel.value.date = Date()
		memoModel.value.index = -1
		insertInCoreData(memoModel: memoModel.value)
	}

	func memoContentUpdate(content: String) {
		let title = content.split(separator: "\n", maxSplits: 1).map(String.init)
		if title.count == 0 { return }
		memoModel.value.homeTitle = title[0]
		memoModel.value.homeContent = (title.count > 1) ? title[1] : "추가 텍스트 없음"
		memoModel.value.content = content
		memoModel.value.date = Date()
		updateInCoreData(memoModel: memoModel.value)
	}

	func memoContentDelete() {
		deleteCoreData(memoModel: memoModel.value)
	}
}

class CoreDataCRUD: NSObject {
	func fetchFromCoreData() -> [MemoModel] {
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
				memoModel.index	= Int(entity.index)
				memoModelList.append(memoModel)
			}
			return memoModelList
		} catch {
			print(error.localizedDescription)
			return []
		}
	}

	func insertInCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "MemoEntity", in: context)

		let content = NSManagedObject(entity: entity!, insertInto: context)
		content.setValue(memoModel.content, forKey: "content")
		content.setValue(memoModel.homeTitle, forKey: "homeTitle")
		content.setValue(memoModel.homeContent, forKey: "homeContent")
		content.setValue(memoModel.date, forKey: "date")
		content.setValue(memoModel.index, forKey: "index")

		saveContext(context)
	}

	func updateInCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MemoEntity")
		fetchRequest.predicate = NSPredicate(format: "index == \(-1)")

		do {
			let results = try context.fetch(fetchRequest) as? [MemoEntity]
			if results?.count != 0 {
				results?[0].setValue(memoModel.content, forKey: "content")
				results?[0].setValue(memoModel.homeTitle, forKey: "homeTitle")
				results?[0].setValue(memoModel.homeContent, forKey: "homeContent")
				results?[0].setValue(memoModel.date, forKey: "date")
//				results?[0].setValue(memoModel.index, forKey: "index")
			}
			saveContext(context)
		} catch {
			print(error.localizedDescription)
		}
	}

	func setTempIndexCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MemoEntity")
		fetchRequest.predicate = NSPredicate(format: "index == \(memoModel.index)")

		do {
			let results = try context.fetch(fetchRequest) as? [MemoEntity]
			if results?.count != 0 {
				results?[0].setValue(-1, forKey: "index")
			}
			saveContext(context)
		} catch {
			print(error.localizedDescription)
		}
	}

	func setFirstIndexCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MemoEntity")
		fetchRequest.predicate = NSPredicate(format: "index == \(-1)")

		do {
			let results = try context.fetch(fetchRequest) as? [MemoEntity]
			if results?.count != 0 {
				results?[0].setValue(0, forKey: "index")
			}
			saveContext(context)
		} catch {
			print(error.localizedDescription)
		}
	}

	func ascendIndexCoreData(change index: Int) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MemoEntity")
		fetchRequest.predicate = NSPredicate(format: "index == \(index)")

		do {
			let results = try context.fetch(fetchRequest) as? [MemoEntity]
			if results?.count != 0 {
				results?[0].setValue(index + 1, forKey: "index")
			}
			saveContext(context)
		} catch {
			print(error.localizedDescription)
		}
	}

	func deleteCoreData(memoModel: MemoModel) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MemoEntity")
		fetchRequest.predicate = NSPredicate(format: "index == \(-1)")

		do {
			guard let results = try context.fetch(fetchRequest) as? [MemoEntity] else { return }
			if results.count != 0 {
				context.delete(results[0])
			}
			saveContext(context)
		} catch {
			print(error.localizedDescription)
		}
	}

	private func saveContext(_ context: NSManagedObjectContext) {
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
	}
}
