
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var activeTextField: UITextField?
    var email: String?
    var password: String?
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard Backendless.sharedInstance().userService.currentUser == nil else {
            if Backendless.sharedInstance().userService.isValidUserToken() {
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startGame), userInfo: nil, repeats: false)
            }
            else {
                Backendless.sharedInstance().userService.logout({
                }, error: { fault in
                    if fault?.faultCode == "404" {
                        AlertViewController.sharedInstance.showErrorAlertWithExit(self)
                    }
                })
            }
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.setToolbarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.setToolbarHidden(false, animated: animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    @IBAction func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @IBAction func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func startGame() {
        self.performSegue(withIdentifier: "segueToTapMe", sender: nil)
    }
    
    func login(_ userEmail: String, _ userPassword: String) {
        let queryBuilder = DataQueryBuilder()!
        queryBuilder.setWhereClause(String(format: "user.email = '%@'", userEmail))
        Backendless.sharedInstance().data.of(Player.ofClass()).find(queryBuilder, response: { foundPlayers in
            if foundPlayers?.first != nil {
                Backendless.sharedInstance().userService.setStayLoggedIn(true)
                Backendless.sharedInstance().userService.login(userEmail, password: userPassword, response: { loggedInUser in
                    self.startGame()
                }, error: { fault in
                    if fault?.faultCode == "3087" {
                        AlertViewController.sharedInstance.showErrorAlert(Fault(message: fault?.message, detail: "Please confirm your email address so you can login"), self)
                    }
                    else {
                        AlertViewController.sharedInstance.showErrorAlert(fault!, self)
                    }                    
                })
            }
            else {
                AlertViewController.sharedInstance.showRegisterPlayerAlert(self)
            }
        }, error: { fault in
            if fault?.faultCode == "404" {
                AlertViewController.sharedInstance.showErrorAlertWithExit(self)
            }
            else {
                AlertViewController.sharedInstance.showErrorAlert(fault!, self)
            }
        })
    }
    
    @IBAction func unwindToLoginVC(_ segue: UIStoryboardSegue) {
        if segue.source.isKind(of: RegisterViewController.ofClass()) {
            login(email!, password!)
        }
    }
    
    @IBAction func pressedSignIn(_ sender: Any) {
        self.view.endEditing(true)
        self.login(self.emailField.text!, self.passwordField.text!)
        self.emailField.text = ""
        self.passwordField.text = ""
    }
}
