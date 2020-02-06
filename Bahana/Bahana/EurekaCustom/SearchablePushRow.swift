//
//  SearchablePushRow.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/03.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import Eureka

open class _SearchSelectorViewController<Row: SelectableRowType, OptionsRow: OptionsProviderRow>: SelectorViewController<OptionsRow>, UISearchResultsUpdating where Row.Cell.Value: SearchableItem {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var originalOptions = [ListCheckRow<Row.Cell.Value>]()
    var currentOptions = [ListCheckRow<Row.Cell.Value>]()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        definesPresentationContext = true

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            //navigationItem.hidesSearchBarWhenScrolling = true
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        if query.isEmpty {
            currentOptions = originalOptions
        } else {
            currentOptions = originalOptions.filter { $0.selectableValue?.matchesSearchQuery(query) ?? false }
        }
        tableView.reloadData()
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentOptions.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = currentOptions[indexPath.row]
        option.updateCell()
        return option.baseCell
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentOptions[indexPath.row].didSelect()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    open override func setupForm(with options: [OptionsRow.OptionsProviderType.Option]) {
        super.setupForm(with: options)
        if let allRows = form.first?.map({ $0 }) as? [ListCheckRow<Row.Cell.Value>] {
            originalOptions = allRows
            currentOptions = originalOptions
        }
        tableView.reloadData()
    }
}

open class SearchSelectorViewController<OptionsRow: OptionsProviderRow>: _SearchSelectorViewController<ListCheckRow<OptionsRow.OptionsProviderType.Option>, OptionsRow> where OptionsRow.OptionsProviderType.Option: SearchableItem {
}

public class _SearchablePushRow<Cell: CellType> : SelectorRow<Cell> where Cell: BaseCell, Cell.Value : SearchableItem {
    public required init(tag: String?) {
        super.init(tag: tag)
        presentationMode = .show(controllerProvider: ControllerProvider.callback { return SearchSelectorViewController<SelectorRow<Cell>> { _ in } }, onDismiss: { vc in
            let _ = vc.navigationController?.popViewController(animated: true) })
    }
}

public final class SearchablePushRow<T: Equatable> : _SearchablePushRow<PushSelectorCell<T>>, RowType where T: SearchableItem {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

public protocol SearchableItem {
    func matchesSearchQuery(_ query: String) -> Bool
}
