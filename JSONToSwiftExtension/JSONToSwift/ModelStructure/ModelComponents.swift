//
//  ModelComponents.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/18.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

/// 模型中的变量信息
/// A strcture to store the various components of a model file.
internal struct ModelComponents {
    /// Declaration of properties.
    var declarations: [String]
    /// String constants to store the keys.
    var stringConstants: [String]
    /// Initialisers for the properties.
    var initialisers: [String]
    // Initialiser function's assignment and function parameters for classes.
    var initialiserFunctionComponent: [InitialiserFunctionComponent]

    /// Initialise a blank model component structure.
    init() {
        declarations = []
        stringConstants = []
        initialisers = []
        initialiserFunctionComponent = []
    }
}

internal struct InitialiserFunctionComponent {
    var functionParameter: String
    var assignmentString: String
}
