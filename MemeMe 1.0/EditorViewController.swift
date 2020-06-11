//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Kemal Kaynak on 04.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let defaultTopTextFieldText = "TOP"
    let defaultBottomTextFieldText = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupShareButtonState()
        setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupShareButtonState() {
        shareButton.isEnabled = memeImageView.image != nil
    }
}

// MARK: - IBActions -

extension EditorViewController {
    
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func albumAction(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        if let memeImage = generateMemedImage() {
            let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    self.saveImage(memeImage)
                }
            }
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        topTextField.text = defaultTopTextFieldText
        bottomTextField.text = defaultBottomTextFieldText
        memeImageView.image = nil
        setupShareButtonState()
    }
}

// MARK: - Get UITextField Attributes -

extension EditorViewController {
    
    func setupTextFields() {
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strokeColor: UIColor.black,
                                                             NSAttributedString.Key.foregroundColor: UIColor.white,
                                                             NSAttributedString.Key.font: UIFont(name: "impact", size: 44)!,
                                                             NSAttributedString.Key.strokeWidth: -3.0]
        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
}

// MARK: - UIImagePicker Delegate -

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            memeImageView.image = image
            setupShareButtonState()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITextField Delegate -

extension EditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isTextFieldEmpty(textField) {
            if textField == topTextField {
                topTextField.text = defaultTopTextFieldText
            } else {
                bottomTextField.text = defaultBottomTextFieldText
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func isTextFieldEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.isEmpty else { return false }
        return true
    }
}

// MARK: - Keyboard Notification -

extension EditorViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification.userInfo)
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ info: [AnyHashable: Any]?) -> CGFloat {
        guard let keyboardHeight = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0.0
        }
        return keyboardHeight.cgRectValue.height
    }
}

// MARK: - Generate Meme Image -

extension EditorViewController {
    
    func generateMemedImage() -> UIImage? {
        setupSystemBarVisibility(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        if let memedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            setupSystemBarVisibility(false)
            return memedImage
        }
        UIGraphicsEndImageContext()
        setupSystemBarVisibility(false)
        return nil
    }
    
    func setupSystemBarVisibility(_ isHidden: Bool) {
        memeToolbar.isHidden = isHidden
        navigationController?.navigationBar.isHidden = isHidden
    }
}

// MARK: - Save Image -

extension EditorViewController {
    
    func saveImage(_ memedImage: UIImage) {
        guard topTextField.text != nil, bottomTextField.text != nil, memeImageView.image != nil else { return }
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
    }
}
