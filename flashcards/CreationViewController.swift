//
//  CreationViewController.swift
//  flashcards
//
//  Created by Innocent Munai on 3/18/22.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    
    var initialQuestion: String!
    var initialAnswer: String!
    var initialExtraAnswerOne: String?
    var initialExtraAnswerTwo: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        extraOneTextField.text = initialExtraAnswerOne
        extraTwoTextField.text = initialExtraAnswerTwo

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // IBOutlest for the question and answer text fields objects
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var extraOneTextField: UITextField!
    @IBOutlet weak var extraTwoTextField: UITextField!
    
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // Get the question and answers
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        let extraOneText = extraOneTextField.text
        let extraTwoText = extraTwoTextField.text
        
        // Create alerts for missing question and answer
        let alert = UIAlertController(title: "Missing text", message: "You need both a question and an answer" , preferredStyle: UIAlertController.Style .alert)
        
        // Ok action created and added to the alerts
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        
        if questionText == nil || questionText!.isEmpty || answerText == nil || answerText!.isEmpty {
            present(alert, animated: true)
        }
        else{
            
            // See if it's existing
            var isExisting = false
            if initialQuestion != nil {
                isExisting = true
            }
                
            // Call the function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraOneText, extraAnswerTwo: extraTwoText, isExisting: isExisting)
        }
        
        // Dismiss
        dismiss(animated: true)
        
    }
    
}
