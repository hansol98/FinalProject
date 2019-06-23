//
//  InsertViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 14/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class InsertViewController: UIViewController {

    // + 버튼 눌러 정보 저장 할 때
    
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textGrade: UITextField!
    @IBOutlet var pickerWatchDate: UIDatePicker!
    @IBOutlet var textReview: UITextView!
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // textfield 테두리 만들기
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textReview.layer.borderWidth = 0.5
        textReview.layer.borderColor = borderColor.cgColor
        textReview.layer.cornerRadius = 5.0
    }
    
    // 저장하기 눌렀을 때
    @IBAction func pressedSave(_ sender: UIBarButtonItem) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Movies", in: context)
        // movie record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textTitle.text, forKey: "movieTitle")
        object.setValue(textGrade.text, forKey: "grade")
        object.setValue(textReview.text, forKey: "review")
        object.setValue(pickerWatchDate.date, forKey: "watchDate")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.movieName.append(textTitle.text!)   // 영화 이름 appDelegate에 저장
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
