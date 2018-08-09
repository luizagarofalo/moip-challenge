//
//  Result.swift
//  moip-challenge
//
//  Created by Luiza Garofalo on 08/08/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

enum Result<T> {
    case positive(T)
    case negative(Error)
}
