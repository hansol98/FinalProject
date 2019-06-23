//
//  JoinViewController.swift
//  FinalProject
//
//  Created by SWUCOMPUTER on 14/06/2019.
//  Copyright © 2019 SWUCOMPUTER. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {

    // 회원가입 버튼 눌렸을 때
    
    // 필요한 아울렛 정의
    @IBOutlet var textID: UITextField!
    @IBOutlet var textPW: UITextField!
    @IBOutlet var textNN: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    // textField에 값 입력되면 자동으로 커서 내리기
    func textFieldShouldReturn (_ textField: UITextField) -> Bool { //delegate method
        if textField == self.textID {
            textField.resignFirstResponder()
            self.textPW.becomeFirstResponder() // ID 입력 후 비번으로 이동
        }
        else if textField == self.textPW {
            textField.resignFirstResponder()
            self.textNN.becomeFirstResponder() // 비번 입력 후 이름으로 이동
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelStatus.text = ""   // 처음엔 label에 아무것도 뜨지 않게 하기
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressJoin(_ sender: UIButton) {
        // 필요한 세 가지 자료가 모두 입력 되었는지 확인
        if textID.text == "" {
            labelStatus.text = "ID를 입력하세요"; return;
        }
        if textPW.text == "" {
            labelStatus.text = "Password를 입력하세요"; return;
        }
        if textNN.text == "" {
            labelStatus.text = "사용자 이름을 입력하세요"; return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/T13/login/insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + textID.text! + "&password=" + textPW.text!
            + "&name=" + textNN.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
    }
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    self.labelStatus.text = utf8Data
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
        }
        task.resume()
    }
    
    // X버튼 눌렸을 때 모달 내리기
    @IBAction func pressBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
