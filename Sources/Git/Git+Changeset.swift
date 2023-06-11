//
//  Created by Mike Gerasymenko <mike@gera.cx>
//

import Foundation
import PathKit
import Logger
import Shell

extension Git {    
    public func changeset(baseBranch: String, verbose: Bool = false) throws -> Set<Path> {
        let gitRoot = try repoRoot()
        
        let currentBranch = try Shell.execOrFail("cd \(gitRoot) && git branch --show-current").trimmingCharacters(in: .newlines)
        if verbose {
            Logger.message("Current branch: \(currentBranch)")
            Logger.message("Base branch: \(baseBranch)")
        }
        
        guard !currentBranch.isEmpty else {
            throw "Missing current branch at \(path)"
        }
        
        let changes = try Shell.execOrFail("cd \(path) && git diff \(baseBranch)..\(currentBranch) --name-only")
        let changesTrimmed = changes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !changesTrimmed.isEmpty else {
            return Set()
        }
        
        return Set(changesTrimmed.components(separatedBy: .newlines).map { gitRoot + $0 } )
    }
    
    public func localChangeset() throws -> Set<Path> {
        let gitRoot = try repoRoot()
        
        let changes = try Shell.execOrFail("cd \(gitRoot) && git diff --name-only")
        let changesTrimmed = changes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !changesTrimmed.isEmpty else {
            return Set()
        }
        
        return Set(changesTrimmed.components(separatedBy: .newlines).map { gitRoot + $0 } )
    }
}