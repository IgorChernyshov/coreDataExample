//
//  MainViewController.swift
//  coreDataExample
//
//  Created by Игорь Чернышов on 08.10.2023.
//

import CoreData
import UIKit

final class MainViewController: UIViewController {

	// MARK: - Subviews
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellReuseID")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	// MARK: - State
	private lazy var fetchedResultsController: NSFetchedResultsController<Emoji> = {
		let controller = CoreDataManager.shared.createFetchedResultsController()
		controller.delegate = self
		try? controller.performFetch()
		return controller
	}()

	private var emojis: [Emoji] { fetchedResultsController.fetchedObjects ?? [] }

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupSubviews()
	}

	// MARK: - UI Configuration
	private func setupNavigationBar() {
		navigationItem.title = "😏 Core Data Example 🍌"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
															style: .plain,
															target: self,
															action: #selector(plusButtonDidTap))
	}

	private func setupSubviews() {
		view.backgroundColor = .systemBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .systemBackground
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	// MARK: - Tap Actions
	@objc
	private func plusButtonDidTap() {
		CoreDataManager.shared.createEmoji()
	}
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		emojis.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseID", for: indexPath)

		var contentConfiguration = cell.defaultContentConfiguration()
		contentConfiguration.text = emojis[indexPath.row].content
		contentConfiguration.secondaryText = emojis[indexPath.row].dateCreated?.formatted()
		cell.contentConfiguration = contentConfiguration

		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		CoreDataManager.shared.updateEmoji(emojis[indexPath.row])
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			CoreDataManager.shared.deleteEmoji(emojis[indexPath.row])
		}
	}
}

// MARK: - NSFetchedResultsControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .automatic)
		case .delete:
			guard let indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .automatic)
		case .move:
			guard let indexPath, let newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			print("Unexpected change type")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
}
