//
//  main.swift
//  diff
//
//  Created by He,Junqiu on 2018/3/12.
//  Copyright © 2018年 hejunqiu. All rights reserved.
//

import Foundation
import printc
import cfunctions

if CommandLine.argc != 3 {
    print("Usage: diff <branch|tag|commit> <branch|tag|commit>")
    exit(1)
}

let firstBranch = CommandLine.arguments[1]
let secondBranch = CommandLine.arguments[2]

func nextMsg(rest count: Int) {
    print("There rest \(count) diffs. Continue? (y/n): ")
    fflush(stdin)
    if let command = String(data: FileHandle.standardInput.availableData, encoding: .utf8)?.first {
        switch command {
        case "y", "\n": break
        case "n": exit(0)
        default: exit(2)
        }
    } else {
        exit(3)
    }
    printc.console.clear()
}


func work() {
    guard let diffResult = _exec("git diff \(firstBranch) \(secondBranch)") else {
        return
    }
    let scanner = Scanner(string: diffResult)
    var contents: [String] = []
    while scanner.isAtEnd == false {
        var content = ""
        var tmp: NSString?
        if scanner.scanString("diff --git a/", into: &tmp) {
            content += tmp! as String
        } else {
            break
        }
        if scanner.scanUpTo("diff --git a/", into: &tmp) {
            content += tmp! as String
        } else {
            break;
        }
        contents.append(content)
    }
    for (idx, content) in contents.enumerated() {
        let lines = content.split(separator: "\n")
        if let index = lines.first?.range(of: "/", options: .backwards, range: nil, locale: nil) {
            printc.println(text: String(lines.first![index.upperBound...]), marks: .red, .bold)
        }
        var index = 0
        while lines[index].first != "@" {
            printc.println(text: String(lines[index]), marks: .bold)
            index += 1
        }

        for line in lines[index...] {
            if line.first == "@" {
                let index = line.range(of: "@", options: .backwards, range: nil, locale: nil)!
                printc.print(text: String(line[...index.lowerBound]), marks: .navy)
                printc.println(text: String(line[index.upperBound...]))
            } else if line.first == "-" {
                printc.println(text: String(line), marks: .red)
            } else if line.first == "+" {
                printc.println(text: String(line), marks: .green)
            } else {
                print(line)
            }
        }
        let rest = contents.count - idx - 1
        if rest != 0 {
            nextMsg(rest: rest)
        }
    }
}

work()

