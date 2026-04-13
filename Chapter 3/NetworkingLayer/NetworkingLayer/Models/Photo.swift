//
//  Photo.swift
//  NetworkingLayer
//
//  Created by Eric Vennaro on 11/26/22.
//

import Foundation
    
struct Photo: ModelProto {
    let albumID: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailURL: URL
}
