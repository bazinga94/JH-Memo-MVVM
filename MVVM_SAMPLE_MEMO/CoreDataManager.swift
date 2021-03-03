//
//  CoreDataManager.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/03/03.
//

import CoreData

class CoreDataManager {
	static let sharedManager = CoreDataManager()

	private init() {}

	// MARK: - Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "MemoModel")

		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()

	func fetchFromCoreData() -> [MemoModel] {
		var memoModelList: [MemoModel] = []
		let context = persistentContainer.viewContext

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
		let context = persistentContainer.viewContext
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
		let context = persistentContainer.viewContext
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
		let context = persistentContainer.viewContext
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
		let context = persistentContainer.viewContext
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
		let context = persistentContainer.viewContext
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
		let context = persistentContainer.viewContext
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

	// MARK: - Core Data Saving support
	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
