//
//  SignUpControllerExt.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/13/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handlemLogo(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage:UIImage? = UIImage()
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }
        mLogo.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
