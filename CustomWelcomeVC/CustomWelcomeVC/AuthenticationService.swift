//
//  AuthenticationService.swift
//  AWS Amplify Combine Demo
//
//  Created by Son Ngo on 2/19/20.
//  Copyright © 2020 Son Ngo. All rights reserved.
//

import Foundation
import AWSMobileClient
import Combine

class AuthenticationService {

    static let instance = AuthenticationService()

    var userState = UserState.unknown

    func getUserState() -> AnyPublisher<UserState?, Error> {
        return Future<UserState?, Error> { promise in
            AWSMobileClient.default().initialize { (userState, error) in
                if let error = error {
                    return promise(.failure(error))
                } else {
                    return promise(.success(userState))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signIn(userName: String, password: String) -> AnyPublisher<SignInResult?, Error> {
        return Future<SignInResult?, Error> { promise in
            AWSMobileClient.default().signIn(username: userName, password: password) { (signInResult, error) in

                guard error == nil else {
                    print("Sign In > UserName: \(userName) > Password: \(password) > Error: \(error!.localizedDescription)")
                    return promise(.failure(error!))
                }
                
                promise(.success(signInResult))
            }
        }.eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            AWSMobileClient.default().signOut { (error) in

                guard error == nil else {
                    print("Unable to sign out: \(error!.localizedDescription)")
                    promise(.failure(error!))
                    return
                }
                
                print("Logout successful")
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }

    func signUp(username: String, password: String) -> AnyPublisher<SignUpResult?, Error> {
        let UUIDString = UUID().uuidString
        return Future<SignUpResult?, Error> { promise in
            AWSMobileClient.default().signUp(username: UUIDString, password: password,   userAttributes: ["email" : username.lowercased()]) { (signUpResult, error) in
                guard error == nil else {
                    print("Sign up > UserName: \(username) > Password: \(password) > Error: \(error!.localizedDescription)")
                    return promise(.failure(error!))
                }
                promise(.success(signUpResult))
            }
        }.eraseToAnyPublisher()
    }
}
