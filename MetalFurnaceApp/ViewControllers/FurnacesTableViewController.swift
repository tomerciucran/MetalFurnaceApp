//
//  FurnacesTableViewController.swift
//  MetalFurnaceApp
//
//  Created by Tomer Ciucran on 03.01.18.
//  Copyright © 2018 Cihan Muradoglu. All rights reserved.
//

import UIKit

class FurnacesTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var furnaces: [Furnace] = []

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
            furnaces = try context.fetch(Furnace.fetchRequest())
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
        return furnaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FurnaceTableViewCell.cellIdentifier, for: indexPath) as! FurnaceTableViewCell
        let furnace = furnaces[indexPath.row]
        if let name = furnace.name {
            cell.titleLabel.text = name
        }
        cell.subtitleLabel.text = "\(furnace.capacity) kg"
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Sil") { [weak self] (action, indexPath) in
            guard let `self` = self else { return }
            let furnace = self.furnaces[indexPath.row]
            self.furnaces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.context.delete(furnace)
        }
        
        return [delete]
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Fırın ekle", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ekle", style: .default) { [weak self] alertAction in
            guard let `self` = self else { return }
            let nameTextField = alert.textFields![0] as UITextField
            let capacitytextField = alert.textFields![1] as UITextField
            
            guard let name = nameTextField.text, name != "" else { return }
            guard let capacityString = capacitytextField.text, let capacity = Int32(capacityString) else { return }
            
            let furnace = Furnace(context: self.context)
            furnace.name = name
            furnace.capacity = capacity
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            alert.dismiss(animated: true, completion: nil)
            self.getData()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "İsim girin"
        }
        
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Kapasite girin (kg)"
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler:nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
