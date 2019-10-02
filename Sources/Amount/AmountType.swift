//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2019-10-02.
//

import Foundation

public protocol AmountType: BinaryInteger {}

public protocol UnsignedAmountType: AmountType & UnsignedInteger {}
public protocol SignedAmountType: AmountType & SignedInteger {}
