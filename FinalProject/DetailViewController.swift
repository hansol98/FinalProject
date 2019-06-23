//
//  DetailViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 14/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    // 테이블 뷰에서 셀 눌렀을 때
    
    @IBOutlet var textMovieTitle: UILabel!
    @IBOutlet var textWatchMovie: UILabel!
    @IBOutlet var textMovieGrade: UILabel!
    @IBOutlet var textMovieReview: UITextView!
    
    var detailMovie: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // textField 테두리 색
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textMovieReview.layer.borderWidth = 0.5
        textMovieReview.layer.borderColor = borderColor.cgColor
        textMovieReview.layer.cornerRadius = 5.0
        
        // 테이블 뷰에서 받아온 정보 세팅하기
        if let movie = detailMovie {
            textMovieTitle.text = movie.value(forKey: "movieTitle") as? String
//            textWatchMovie.text = movie.value(forKey: "watchDate") as? String
            textMovieGrade.text = (movie.value(forKey: "grade") as? String)! + "점"
            textMovieReview.text = movie.value(forKey: "review") as? String
            
            let dbDate: Date? = movie.value(forKey: "watchDate") as? Date
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let unwrapDate = dbDate {
                textWatchMovie.text = formatter.string(from: unwrapDate as Date)
            }
        }
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
