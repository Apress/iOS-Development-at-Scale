//
//  LaunchState.swift
//  VIPER
//
//  Created by Eric Vennaro on 2/4/23.
//

import Foundation
import Combine


enum LaunchState {
    case main, auth, onboarding
    
    // setting true for demo purposes
    static func configure(
        tutorialWasShown: Bool = true,
        isAuthorized: Bool = true
    ) -> LaunchState {
    
    switch (tutorialWasShown, isAuthorized) {
      case (true, false), (false, false): return .auth
      case (false, true): return .onboarding
      case (true, true): return .main
    }
  }
}
