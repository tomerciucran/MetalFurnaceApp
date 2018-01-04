//
//  EntriesTableViewController.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 03.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var entries: [Entry] = []
    private var furnaces: [Furnace] = []
    private var scraps: [Scrap] = []
    
    var headerView: EntriesTableViewHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        createHeaderView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        do {
            furnaces = try context.fetch(Furnace.fetchRequest())
            scraps = try context.fetch(Scrap.fetchRequest())
            headerView?.furnaces = furnaces
            headerView?.scraps = scraps
        } catch {
            print("Fetching Failed")
        }
    }
    
    // MARK: - Table View Header
    
    private func createHeaderView() {
        
        headerView = EntriesTableViewHeader.instanceFromNib("EntriesTableViewHeader") as! EntriesTableViewHeader
        headerView.furnaces = furnaces
        headerView.scraps = scraps
        headerView.delegate = self
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        let containerView = UIView(frame: headerView.frame)
        containerView.addSubview(headerView)
        
        self.tableView.tableHeaderView = containerView
    }
    
    // MARK: - Configure Views
    
    internal func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: EntryTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
}

extension EntriesTableViewController: EntriesTableViewHeaderDelegate {
    func didTapAddButton() {
        
    }
    
    func didTapPickerDoneButton() {
        view.endEditing(true)
    }
    
    func didTapAddFurnacesButton() {
        performSegue(withIdentifier: Segue.GoToFurnaces, sender: nil)
    }
    
    func didTapAddScrapButton() {
        performSegue(withIdentifier: Segue.GoToScraps, sender: nil)
    }
}
