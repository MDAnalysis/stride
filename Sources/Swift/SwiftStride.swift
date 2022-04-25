import Foundation
import CStride

// Handles reading files and performing the stride algorithm
public class Stride {
    
    public init() {
        
    }
    
    /// Runs Stride with the given file and returns an array of Residues containing the information of the secondary structure
    /// - Parameters:
    ///   - file: The path to the file
    ///   - arguments: Optional Stride arguments:
    ///     -fFile           Output file
    ///     -mFile         MolScript file
    ///     -o Report    Secondary structure summary only
    ///     -h Report    Hydrogen bonds
    ///     -rId1Id2...    Read only chains Id1, Id2 ...
    ///     -cId1Id2...   Process only Chains Id1, Id2 ...
    ///     -q[File]     Generate SeQuence file in FASTA format and close the program
    ///     -fFile           Output file
    public static func predict(from file: String, arguments arg: [String]? = nil) -> [Residue]? {
        
        var arguments = ["main", file] /// Basic compulsory arguments to run the program
        
        // Appends the optional arguments to the main arg array with all the arguments
        if let arg = arg {
            arg.forEach { a in
                arguments.append(a)
            }
        }
        
        var cArgs = arguments.map {strdup($0)}
        
        let result = stride(Int32(arguments.count), &cArgs)
        
        // Deallocate arguments
        for ptr in cArgs {
            ptr?.deallocate()
        }
        
        // Process the aminoacids and return the value
        return processResult(result: result)

    }

    private static func processResult(result: RChain) -> [Residue]? {
        
        var residues: [Residue] = []
        
        for n in 0..<result.NChain {
            let c = result.chain[Int(n)]!.pointee
            for i in 0..<c.NRes {
                
                let cResidue = c.Rsd[Int(i)]!
                
                guard let type = getAA(from: unsafePointerToString(value: cResidue.pointee.ResType)) else {return nil}
                
                guard let structure = getStructure(from: unsafePointerToString(value: cResidue.pointee.Prop.pointee.Asn)) else {return nil}
                
                let phi = cResidue.pointee.Prop.pointee.Phi
                
                let psi = cResidue.pointee.Prop.pointee.Psi
                
                let area = cResidue.pointee.Prop.pointee.Solv
                
                let newResidue = Residue(type: type, structure: structure, phi: phi, psi: psi, area: area)
                
                residues.append(newResidue)
                
            }
        }
        
        return residues
    }
    
    private static func getAA(from code: String) -> AminoAcid? {
        for aa in AminoAcid.allCases {
            if aa.code.uppercased() == code { return aa }
        }
        return nil
    }
    
    private static func getStructure(from code: String) -> SecondaryStructure? {
        guard let l = code.first else {return nil}
        for structure in SecondaryStructure.allCases {
            if String(l) == structure.rawValue {return structure}
        }
        return nil
    }
    
}



/// Transform an unsafe pointer a.k.a a tuple of Chars (Int8, Int8, ...) to a Swift string
private func unsafePointerToString<T>(value: T) -> String {
    return withUnsafePointer(to: value) { ptr in
        ptr.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: ptr)) {String(cString: $0)}
    }
}



