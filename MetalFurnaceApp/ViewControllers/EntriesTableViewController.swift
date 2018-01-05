//
//  EntriesTableViewController.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 03.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit
import MessageUI

class EntriesTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var entries: [Entry] = [] {
        didSet {
            headerView?.entries = entries
        }
    }
    private var furnaces: [Furnace] = [] {
        didSet {
            headerView?.furnaces = furnaces
        }
    }
    private var scraps: [Scrap] = [] {
        didSet {
            headerView?.scraps = scraps
        }
    }
    
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
    
    // MARK: - Actions
    
    @IBAction func sendButtonAction(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tomercukran@gmail.com"])
            mail.setSubject("deneme")
            
            var body = ""
            for entry in entries {
                body += "\(entry.dateString) \(entry.furnace.name ?? "") \(entry.scrap.name ?? "") \(entry.amount) kg\n"
            }
            
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
        } else {
            showAlert(title: "Hata", message: "Lütfen e-posta ayarlarınızı kontrol edin.")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.cellIdentifier, for: indexPath) as! EntryTableViewCell
        let entry = entries[indexPath.row]
        cell.dateLabel.text = entry.dateString
        cell.furnaceNameLabel.text = entry.furnace.name
        cell.scrapNameLabel.text = entry.scrap.name
        cell.amountLabel.text = "\(entry.amount.formatted()) kg"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] (action, indexPath) in
            guard let `self` = self else { return }
            self.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension EntriesTableViewController: EntriesTableViewHeaderDelegate {
    func didTapAddButton(furnace: Furnace, scrap: Scrap, amount: Int, completion: () -> Void) {
        entries.insert(Entry(date: Date(), furnace: furnace, scrap: scrap, amount: amount), at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        completion()
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

extension EntriesTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
