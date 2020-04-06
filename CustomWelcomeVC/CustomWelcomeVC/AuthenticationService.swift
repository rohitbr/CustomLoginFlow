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
//import KRProgressHUD

class AuthenticationService : ObservableObject {

    // static properties
    static let instance = AuthenticationService()

    // Published properties
    @Published private(set) var userState = UserState.unknown
    @Published private(set) var userInfo:[String: String] = [:]

    private init() {
        print("items allocated in user state")
        
        AWSMobileClient.default().addUserStateListener(self) { [weak self] (userState, info) in
            DispatchQueue.main.async {
                self?.userState = userState
                self?.userInfo = info
            }
        }
        
        AWSMobileClient.default().initialize { [unowned self] (userState, error) in
            self.userState = userState ?? UserState.unknown
        }
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
