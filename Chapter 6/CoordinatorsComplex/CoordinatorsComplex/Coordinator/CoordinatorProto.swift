//
//  CoordinatorProto.swift
//  CoordinatorsComplex
//
//  Created by Eric Vennaro on 1/1/23.
//

import Foundation

protocol CoordinatorProto: AnyObject {
    var router: RouterProto { get set }
    var finishFlow: (() -> Void)? { get set }
    func start()
    func start(with option: DeepLinkOption?)
}

