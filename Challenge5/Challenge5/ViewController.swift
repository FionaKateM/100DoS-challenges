//
//  ViewController.swift
//  Challenge5
//
//  Created by Fiona Kate Morgan on 02/04/2019.
//  Copyright © 2019 Fiona Kate Morgan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        let defaults = UserDefaults.standard
        
        if let savedItems = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                items = try jsonDecoder.decode([Item].self, from: savedItems)
            } catch {
                print("failed to load saved items")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].caption
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = items[indexPath.row].image
            vc.caption = items[indexPath.row].caption
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNewItem() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        let item = Item(caption: "Image \(items.count + 1)", image: imageName)
        items.append(item)
        save()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = items[indexPath.row]
        let editCaptionTitle = NSLocalizedString("Edit", comment: "Edit caption")
        let editAction = UITableViewRowAction(style: .normal,
                                                  title: editCaptionTitle) { (action, indexPath) in
                                                    let alert = UIAlertController(title: "Edit caption", message: nil, preferredStyle: .alert)
                                                    alert.addTextField()
                                                    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
                                                        guard let newCaption = alert?.textFields?[0].text else {return}
                                                        item.caption = newCaption
                                                        self?.save()
                                                        self?.tableView.reloadData()
                                                        
                                                    })
                                                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                                    self.present(alert, animated: true)
        }
        editAction.backgroundColor = .blue
        return [editAction]
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

    func save() {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(items) {
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "items")
        } else {
            print("failed to save items")
        }
    }

}

