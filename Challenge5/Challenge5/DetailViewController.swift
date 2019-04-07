//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Fiona Kate Morgan on 07/04/2019.
//  Copyright © 2019 Fiona Kate Morgan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedImage = ""
    var caption = ""
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = getDocumentsDirectory().appendingPathComponent(selectedImage)
        image.image = UIImage(contentsOfFile: path.path)

        captionLabel.text = caption
        
        // Do any additional setup after loading the view.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
