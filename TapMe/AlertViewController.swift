
import UIKit

class AlertViewController: UIViewController {
    
    static let sharedInstance = AlertViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showErrorAlert(_ fault: Fault, _ target: UIViewController) {
        let alert = UIAlertController(title: "❗️Error", message: fault.detail, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        target.view.endEditing(true)
        target.present(alert, animated: true)
    }
    
    func showErrorAlertWithExit(_ target: UIViewController) {
        let alert = UIAlertController(title: "❗️Error", message: "Make sure to configure the app with your APP ID and API KEY before running the app. \nApplication will be closed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            exit(0)
        }))
        target.view.endEditing(true)
        target.present(alert, animated: true)
    }
    
    func showRegisterPlayerAlert(_ target: UIViewController) {
        let alert = UIAlertController(title: "👤 Create a new player", message: "Please sign up as a new player", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        target.view.endEditing(true)
        target.present(alert, animated: true)
    }
    
    func showProfilePicturePicker (_ imageView: UIImageView, _ target: UIViewController) {
        let alert = UIAlertController(title: "👤 Set profie picture", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Use camera", style: .default, handler: { alertAction in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showErrorAlert(Fault(message: "", detail: "No device found. Camera is not available"), target)
            }
            else {
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = .camera
                cameraPicker.delegate = target as! (UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate)
                target.present(cameraPicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Select from gallery", style: .default, handler: { alertAction in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = target as! (UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate)
                imagePicker.allowsEditing = false
                target.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        target.present(alert, animated: true)
    }
    
    func showScoreAlert(_ scores: Int, _ target: UIViewController) {
        let alert = UIAlertController(title: "⭐️ Finish ⭐️", message: String(format: "Your score is %i", scores), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        target.view.endEditing(true)
        target.present(alert, animated: true)
    }
    
    func showCongratulationsAlert(_ message: String, _ target: UIViewController) {
        let alert = UIAlertController(title: "🎉 Congratulations 🎉", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        target.view.endEditing(true)
        target.present(alert, animated: true)
    }
}
