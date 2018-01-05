//
//  ScrapsTableViewController.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 04.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit

class ScrapsTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var scraps: [Scrap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        do {
            scraps = try context.fetch(Scrap.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Fetching Failed")
        }
    }
    
    // MARK: - Configure Views
    
    internal func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .singleLine
        
        tableView.register(UINib(nibName: "FurnaceTableViewCell", bundle: nil), forCellReuseIdentifier: FurnaceTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scraps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FurnaceTableViewCell.cellIdentifier, for: indexPath) as! FurnaceTableViewCell
        let scrap = scraps[indexPath.row]
        if let name = scrap.name {
            cell.titleLabel.text = name
        }
        cell.subtitleLabel.isHidden = true
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] (action, indexPath) in
            guard let `self` = self else { return }
            let scrap = self.scraps[indexPath.row]
            self.scraps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.context.delete(scrap)
        }
        
        return [delete]
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Hurda ekle", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ekle", style: .default) { [weak self] alertAction in
            guard let `self` = self else { return }
            let nameTextField = alert.textFields![0] as UITextField
            
            guard let name = nameTextField.text, name != "" else { return }
            
            let scrap = Scrap(context: self.context)
            scrap.name = name
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            alert.dismiss(animated: true, completion: nil)
            self.getData()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "İsim girin"
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler:nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
