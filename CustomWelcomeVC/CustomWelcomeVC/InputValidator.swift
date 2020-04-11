//
//  InputValidator.swift
//  OneLinkHomeSwiftUI
//
//  Created by Hasan, MdAdit on 3/25/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//


import Foundation


public struct ValidationResult {
    public let isValid: Bool
    public var errorTitle: String? = nil
    public var errorReason: String? = nil
}

public struct InputValidator {
  
    static let escapedSpecialRegexCharacters = "\\^$\\*\\.\\[\\]\\{\\}\\(\\)?\\-\"!@#%&\\/\\\\,><':;\\|_~`"
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let minNumberOfCharactersInPassword = 8
    static let maxNumberOfCharactersInPassword = 256
    static let success = ValidationResult(isValid: true, errorTitle: nil, errorReason: nil)
    

   public static func validate(password: String, isSignIn: Bool) -> ValidationResult {
        guard !password.isEmpty else {
            return ValidationResult(isValid: false,
                                    errorTitle: "Password Required".local,
                                    errorReason:
                "Password field is required.".local)
        }
        
        guard test(string: password, regex: getPasswordRegex()) || isSignIn else {
            return ValidationResult(isValid: false,
                                    errorTitle: "Invalid Password".local,
                                    errorReason: "PASSWORD_RULE".local)
        }
        return InputValidator.success
    }
    
   public static func validate(email: String) -> ValidationResult {
        let tempString:String? = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let trimmedEmail = tempString else {
            return ValidationResult(isValid: false,
                                    errorTitle: "Invalid Email".local,
                                    errorReason: "The email address is invalid. Please try again.".local)
        }
        
        guard !trimmedEmail.isEmpty else {
            return ValidationResult(isValid: false,
                                    errorTitle: "Email Required".local,
                                    errorReason: "Email field is required.".local)
        }
        
        guard test(string: trimmedEmail, regex: emailRegex) else {
            return ValidationResult(isValid: false,
                             errorTitle: "Invalid Email".local,
                             errorReason: "The email address is invalid. Please try again.".local)
        }
        return InputValidator.success
    }
    

   public static func validate(verificationCode: String) -> ValidationResult {
        guard !verificationCode.isEmpty else {
            return ValidationResult(isValid: false, errorTitle: "Invalid Verification Code".local, errorReason: "Verification code is invalid. Please try again.".local)
        }
        return InputValidator.success
    }
    

   public static func validateMatchPassword(field1: String, field2: String) -> ValidationResult {
        guard field1 == field2 else {
            return ValidationResult(isValid: false,
                                    errorTitle: "Password Error".local,
                                    errorReason: "Passwords do not match. Please try again".local)
        }
        
        return InputValidator.success
    }
    
    private static func test(string testString: String, regex: String) -> Bool {
        return testString.range(of: regex, options: .regularExpression) != nil
    }


    private static func getPasswordRegex() -> String {
        return "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\(escapedSpecialRegexCharacters)])[A-Za-z\\d\(escapedSpecialRegexCharacters)]{\(minNumberOfCharactersInPassword),\(maxNumberOfCharactersInPassword)}"
    }
    

   public static func validateAlphaNumeric(text: String)  -> Bool {
        let validCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890").inverted
        return text.rangeOfCharacter(from: validCharacterSet) == nil
    }
    
}

extension String {
    
    public var local:String {
        return NSLocalizedString(self, comment: "")
    }
}
