//
//  FlkrErrors.swift
//  Flickr
//
//  Created by Tancrède on 9/25/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import Foundation



enum FlkrError: ErrorType {
    
    case FailedSetup( message: String?, rootError: ErrorType?)
    case FailedLoadingFromCache( message: String?, rootError: ErrorType?)
    case FailedSavingToCache( message: String?, rootError: ErrorType?)
    case FailedParsingJson( message: String?, rootError: ErrorType?)
    
}