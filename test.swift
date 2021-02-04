//
//  main.swift
//  test_inter
//
//  Created by Brandon Plank on 2/2/21.
//

import Foundation
import SwiftInterpreter
import SwiftInterpreterCore

let stack = Stack()
func addFunctionToStack(_ name: String, _ stack: Stack){
    let siFunc = SimpleSIFunction(stack: stack, body: { stack, params in
        let values = params.getConcreteValues()
        if let first = values.first?.value as? String {
            print(first)
        }
        return Void()
    }, functionSignature: FunctionSignature(identifierName: "\(name)", argumentLabels: ["_"]))
    try? stack.push(siFunc.functionSignature.keyInStack, .constant, siFunc)
}

do {
    addFunctionToStack("print", stack) // print() -> Stack
    let our_beginning_val = 20
    try? stack.push("value", StackElementType.variable, our_beginning_val) // var value: Int = our_beginning_val -> Stack
    let result: Any = try """
print("Running from Interpreted code :D")
let grade1: Double = 100
let grade2: Double = 50

let average = (grade1 + grade2) / 2.0
let new_val = value + 10
var text: String = ""
if(new_val >= 20){
    text = "We are 20 or above"
} else {
    text = "We are less than 20."
}
return average // Pupulates let result: Any
""".interpret(using: stack)
    print(result)
    print(try! stack.get("new_val") as Any) // print(new_val) <- Stack
    print(try! stack.get("text") as Any) // print(text) <- Stack
    print("Running from real code :D")
    
    let value = our_beginning_val // same as try? stack.push("value", StackElementType.variable, our_beginning_val)
    let grade1: Double = 100
    let grade2: Double = 50

    let average = (grade1 + grade2) / 2.0
    let new_val = value + 10
    var text: String = ""
    if(new_val >= 20){
        text = "We are 20 or above"
    } else {
        text = "We are less than 20."
    }
    print(average)
    print(new_val)
    print(text)

} catch let error {
    print("Error:\(error)")
}
