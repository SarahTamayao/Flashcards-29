//
//  ViewController.swift
//  flashcards
//
//  Created by Innocent Munai on 2/26/22.
//

import UIKit


struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String?
    var extraAnswerTwo: String?
}


class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    // Array to store the flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    // Button to remember what the correct answer is
    var correctAnswerButton: UIButton!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Give card it round corners
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        // Give labels rounded corners
        backLabel.layer.cornerRadius = 20.0
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding initial flashcard when needed and updating labels and buttons
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Tanzania?", answer: "Dodoma", extraAnswerOne: "Dar es Salaam", extraAnswerTwo: "Iringa", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }

        // Do any additional setup after loading the view.

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Animation for the flashcard
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
        
        // Start with buttons invisible and slightly smaller in size
        btnOptionOne.alpha = 0.0
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.alpha = 0.0
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.alpha = 0.0
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Animation for the buttons
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.btnOptionOne.alpha = 1.0
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.alpha = 1.0
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
    }

    
    func saveAllFlashcardsToDisk() {
        
        // From flashcards array to dictionary array
        let dictionaryArray = flashcards.map{ (card) -> [String: String?] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        
        // Save flashcards array on disk using UserDefauls
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log that the flashcards saved
        print("🎉 Flashcards saved to UserDefaults")
    }
    
    
    func readSavedFlashcards() {
        
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map{ (dictionary) -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"], extraAnswerTwo: dictionary["extraAnswerTwo"])
            }
            
            // Put these flashcard in the flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    
    // Support multiple choice answer
    @IBAction func didTapOptionOne(_ sender: Any) {
        // If correct answer, flip flashcard else disable button and show front label
        if btnOptionOne == correctAnswerButton{
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionOne.isEnabled = false
        }
    }
    @IBAction func didTapOptionTwo(_ sender: Any) {
        
        // If correct answer, flip flashcard else disable button and show front label
        if btnOptionTwo == correctAnswerButton{
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionTwo.isEnabled = false
        }
    }
    @IBAction func didTapOptionThree(_ sender: Any) {
        // If correct answer, flip flashcard else disable button and show front label
        if btnOptionThree == correctAnswerButton{
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionThree.isEnabled = false
        }
    }
    
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?, isExisting: Bool) {
        
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        
        btnOptionOne.setTitle(flashcard.extraAnswerOne, for: .normal)
        btnOptionTwo.setTitle(flashcard.answer, for: .normal)
        btnOptionThree.setTitle(flashcard.extraAnswerTwo, for: .normal)
        
        // Check if we need to replace or append the new flashcard
        if isExisting {
            
            // Replace existing flashcard
            flashcards[currentIndex] = flashcard
            
        } else {
        
            // Add new flashcard to the array
            flashcards.append(flashcard)
            
            // Log to the console
            print("😎 Added new flashcard")
            print("😎 We now have \(flashcards.count) flashcards")
            
            // Update current index
            currentIndex = flashcards.count - 1
            print("😎 Our current index is \(currentIndex)")
        }
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Set the flashcard to default visibility
        frontLabel.isHidden = false
        btnOptionOne.isHidden = false
        btnOptionThree.isHidden = false
        
        // Save the flashcards to UserDefaults
        saveAllFlashcardsToDisk()
        
    }
    
    
    func updateLabels() {
        
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        // Update buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        // Iterate over both arrays at the same time
        for (button, answer) in zip (buttons, answers){
            
            // Set tittle of random button with this random answer
            button?.setTitle(answer, for: .normal)
            
            // If this is the correct answer, save the button
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
    }
    
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete flashcard?", preferredStyle: .actionSheet)
        
        // Create delete action and add to the alert
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        // Create cancel action and add to the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true)
    }
    
    
    func deleteCurrentFlashcard () {
        
        // Delete flashcard at the current index if not the only remaining card
        if flashcards.count != 1 {
            flashcards.remove(at: currentIndex)
        }
        
        // Special case: check if last card deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        updateLabels()
        updateNextPrevButtons()
        saveAllFlashcardsToDisk()
    }
    
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Update current index
        currentIndex = currentIndex - 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // Animate card out taking it to x = 300.0
        animateCardOut(xval: 300.0)
    }
    
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Update current index
        currentIndex = currentIndex + 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // Animate card out taking it to x = -300.0
        animateCardOut(xval: -300.0)
    }
    
    
    func updateNextPrevButtons() {
        
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
        }
        
        // Disable previous button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
        }
    }
    
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden {
                self.frontLabel.isHidden = false
            }
            else {
                self.frontLabel.isHidden = true
            }
        })
    }
    
    
    func animateCardOut(xval: Float) {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: CGFloat(xval), y: 0.0)
        }, completion: { finished in
            
            // Update labels
            self.updateLabels()
            
            // Run the animation
            self.animateCardIn(xval: -xval)
        })
    }
    
    
    func animateCardIn(xval: Float) {
        
        // Start on the (x = xval) side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: CGFloat(xval), y: 0.0)
        
        // Animate card going back to its orginal position
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // We set the flashcardsController property to self
        creationController.flashcardsController=self
        
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
    
}

