//
//  Created by Mike Gerasymenko <mike@gera.cx>
//

import Foundation
import PathKit
import SelectiveTestLogger
import SelectiveTestShell

public extension Git {
    func changeset(baseBranch: String, verbose: Bool = false) throws -> Set<Path> {
        let gitRoot = try repoRoot()

        var currentBranch = try Shell.execOrFail("cd \(gitRoot) && git branch --show-current").trimmingCharacters(in: .newlines)
        if verbose {
            Logger.message("Current branch: \(currentBranch)")
            Logger.message("Base branch: \(baseBranch)")
        }

        if currentBranch.isEmpty {
            Logger.warning("Missing current branch at \(path)")

            currentBranch = "HEAD"
        }
      Logger.message("path: \(path)")
        let changes = try Shell.execOrFail("cd \(gitRoot) && git diff '\(baseBranch)'..'\(currentBranch)' --name-only")
      Logger.message("changes: \(changes)")
        let changesTrimmed = changes.trimmingCharacters(in: .whitespacesAndNewlines)
        Logger.message("changes trimmed: " + changesTrimmed)
        guard !changesTrimmed.isEmpty else {
            return Set()
        }

     let set = Set(changesTrimmed.components(separatedBy: .newlines).map { gitRoot + $0 })
      let set2 = Set(changesTrimmed.split(whereSeparator: \.isNewline).map { gitRoot + String($0) })
      Logger.message("set contains \(set.count)")
      Logger.message("set2 contains \(set2.count)")
      return set
    }

    func localChangeset() throws -> Set<Path> {
        let gitRoot = try repoRoot()

        let changes = try Shell.execOrFail("cd \(gitRoot) && git diff HEAD --name-only")
        
        let changesTrimmed = changes.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !changesTrimmed.isEmpty else {
            return Set()
        }

        return Set(changesTrimmed.components(separatedBy: .newlines).map { gitRoot + $0 })
    }
}
