//
//  CoreDataManager.swift
//  coreDataExample
//
//  Created by Игорь Чернышов on 08.10.2023.
//

import CoreData

final class CoreDataManager {

	// MARK: - State
	var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
	private let persistentContainer: NSPersistentContainer

	// MARK: - Singleton
	static let shared = CoreDataManager(modelName: "CoreDataModel")

	private init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}

	// MARK: - Lifecycle
	func load() {
		persistentContainer.loadPersistentStores { description, error in
			if let error { fatalError("Could not load persistent stores. \(error.localizedDescription)") }
			print("Loaded persistent store of type \(description.type)")
		}
	}

	func save() {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print("Error saving context changes: \(error.localizedDescription)")
			}
		}
	}

	// MARK: - CRUD
	func createEmoji() -> Emoji {
		let emoji = Emoji(context: viewContext)
		emoji.id = UUID()
		emoji.content = .randomEmoji
		emoji.dateCreated = Date()
		save()
		return emoji
	}

	func readEmojis() -> [Emoji] {
		let request = Emoji.fetchRequest()
		let sortDescriptor = NSSortDescriptor(keyPath: \Emoji.dateCreated, ascending: false)
		request.sortDescriptors = [sortDescriptor]
		return (try? viewContext.fetch(request)) ?? []
	}

	func deleteEmoji(_ emoji: Emoji) {
		viewContext.delete(emoji)
		save()
	}
}
