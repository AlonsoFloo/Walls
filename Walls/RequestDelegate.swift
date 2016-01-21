//
//  RequestDelegate.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import Foundation


protocol RequestDelegate {
    func responseFromWS(array aArray:Array<AnyObject>)
    func errorFromWS()
}