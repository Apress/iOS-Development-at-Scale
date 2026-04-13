//
//  CoordinatorProto.swift
//  MVC+Coord
//
//  Created by Eric Vennaro on 12/30/22.
//

protocol CoordinatorProto: AnyObject {
//    var vcFactory: VCFactoryProto { get set }
    var router: RouterProto { get set }
//    var coordinatorFactory: CoordinatorFactoryProto { get set}
    var finishFlow: (() -> Void)? { get set }
    func start()
    func start(with option: DeepLinkOption?)
}
