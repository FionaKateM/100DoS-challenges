//
//  ViewController.swift
//  Challenge3
//
//  Created by Fiona Kate Morgan on 16/03/2019.
//  Copyright © 2019 Fiona Kate Morgan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var keyboardView: UIView!
    
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var maxLevel = 2
    var words = [String]()
    var selectedWord = ""
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var lives = 7 {
        didSet {
            updateImage()
        }
    }
    var points = 0 {
        didSet {
            scoreLabel.text = "Score: \(points)"
        }
    }
    var letterButtons = [UIButton]()
    var tappedLetters = [String]()
    var guessed = false
    
    @IBOutlet var wordLabel: UILabel!
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if level has already been loaded, if not then parse the JSON for words, otherwise load word from array for game
        if words.isEmpty {
            performSelector(inBackground: #selector(parseJSON), with: nil)
        } else {
            loadWord()
        }
        
        loadButtons()
        updateImage()
    }
    
    @objc func loadWord(_ sender: UIAlertAction! = nil) {
        
        // reset all buttons to unpressed
        for button in letterButtons {
            button.isEnabled = true
            // change colour here too
        }
        
        // reset lives to 7
        lives = 7
        tappedLetters.removeAll()
        guessed = false
        
        if !words.isEmpty {
            words.shuffle()
            selectedWord = words[0].uppercased()
            print(selectedWord)
            words.remove(at: 0)
            wordLabel.text = " "
            updateLabel()
        } else if level == maxLevel {
            let ac = UIAlertController(title: "Game complete", message: "You've played all words on all levels", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next level", style: .default))
            present(ac, animated: true)
        } else {
            // you have played all words in this level. Try another level
            let ac = UIAlertController(title: "Well done", message: "Level \(level) complete", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next level", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    @objc func parseJSON(){
        // check if level file for current level exists
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                // separates everything by line break
                let levelWords = levelContents.components(separatedBy: "\n")
                words = levelWords
                performSelector(onMainThread: #selector(loadWord), with: nil, waitUntilDone: false)
                
            }
        }
    }

    @objc func letterTapped(_ sender: UIButton) {
        let letter = letters[sender.tag]
        if !tappedLetters.contains(letter) {
            tappedLetters.append(letter)
        }
        
        if !selectedWord.contains(Character(letter)) {
            
            lives -= 1
            if lives == 0 {
                gameOver()
            }
            // update hangman image
            
            // turn button gray
            letterButtons[sender.tag].isEnabled = false
            
        } else {
            letterButtons[sender.tag].isEnabled = false
            updateLabel()

        }
    }
    
    func updateLabel() {
        var counter = selectedWord.count
        wordLabel.text = ""
        for letter in selectedWord {
            if tappedLetters.contains(String(letter)) {
                counter -= 1
                wordLabel.text?.append("\(letter)")
            } else {
                wordLabel.text?.append("_ ")
            }
        }
        if counter == 0 {
            points += 1
            print("points: \(points)")
            guessed = true
            gameOver()
        }
    }
    
    func gameOver() {
        var title = ""
        var message = ""
        if guessed {
            title = "Congratulations"
            message = "You correctly guessed \(selectedWord)"
        } else {
            title = "Bad luck"
            message = "It was \(selectedWord)"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Next word", style: .default, handler: loadWord))
        present(ac, animated: true)
    }
    
    @objc func levelUp(_ : UIAlertAction! = nil) {
        if level < maxLevel {
            level += 1
            performSelector(inBackground: #selector(parseJSON), with: nil)
            return
        } else {
            // reached max level and completed game
        }
        
    }
    
    func loadButtons() {
        // height and width of each button
        
        let width: CGFloat = (keyboardView.frame.width / 25) * 3
        let height: CGFloat = width

        for (index, letter) in letters.enumerated() {
            let column = index % 6
            let row = (index - (index % 6)) / 6
            
            let button = UIButton(type: .system)
            button.setTitle(letter, for: .normal)
            button.tag = index
            
            // add target so letter tapped is called when any letter button is tapped
            button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

            let frame = CGRect(x: ((CGFloat(column) * width * 1.25) + (width / 3)), y: (((CGFloat(row)) * (width * 1.25))), width: width, height: height)
            button.frame = frame
            button.layer.cornerRadius = width / 16
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            
            letterButtons.append(button)
            keyboardView.addSubview(button)
        }
    }
    
    func updateImage() {
        for view in view.subviews {
            if let v = view as? UIImageView {
                v.removeFromSuperview()
            }
        }
        
        if lives > 0 {
            let image = UIImageView(image: UIImage(named: "bomb.png"))
            image.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(image)
            
            NSLayoutConstraint.activate([
                image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                image.heightAnchor.constraint(equalToConstant: (view.frame.height / 3) - (CGFloat(lives) * 10 )),
                image.widthAnchor.constraint(equalTo: image.heightAnchor),
                image.bottomAnchor.constraint(equalTo: wordLabel.topAnchor)
                ])
            
        } else {
            let image = UIImageView(image: UIImage(named: "explosion.png"))
            image.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(image)
            
            NSLayoutConstraint.activate([
                image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                image.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
                image.widthAnchor.constraint(equalTo: image.heightAnchor),
                image.bottomAnchor.constraint(equalTo: wordLabel.topAnchor)
                ])
        }
    }
}

