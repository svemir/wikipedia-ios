
import UIKit

enum DiffFetcherError: Error {
    case serializeJSONFailure
    case unexpectedData
    case decodeJSONFailure
    case missingData
    case errorGeneratingURL
    case invalidResponse
}

struct RevisionResult {
    let fromWikitext: String
    let toWikitext: String
}

class DiffFetcher: Fetcher {
    
    func fetchDiffData(siteURL: URL, fromRevisionID: Int, toRevisionID: Int, completion: @escaping (Result<RevisionResult, Error>) -> Void) {
        
        let params: [String: AnyObject] = [
            "action": "query" as AnyObject,
            "prop": "revisions" as AnyObject,
            "revids": "\(fromRevisionID)|\(toRevisionID)" as AnyObject,
            "rvprop": "content" as AnyObject,
            "format": "json" as AnyObject
        ]
        
        performMediaWikiAPIGET(for: siteURL, with: params, cancellationKey: nil) { (result, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let query = result?["query"] as? [String: AnyObject],
                let pages = query["pages"] as? [String: AnyObject] else {
                completion(.failure(DiffFetcherError.unexpectedData))
                return
            }
            
            var from: String?
            var to: String?
            for (_, value) in pages {
                guard let valueDict = value as? [String: AnyObject] else {
                    continue
                }
                
                if let revisionsArray = valueDict["revisions"] as? [[String: AnyObject]] {
                    
                    guard revisionsArray.count == 2 else {
                        continue
                    }
                    
                    let fromDict = revisionsArray[0]
                    let toDict = revisionsArray[1]
                    
                    from = fromDict["*"] as? String
                    to = toDict["*"] as? String
                    break
                }
            }
            
            guard let fromWikitext = from,
                let toWikitext = to else {
                completion(.failure(DiffFetcherError.unexpectedData))
                return
            }
            
            completion(.success(RevisionResult(fromWikitext: fromWikitext, toWikitext: toWikitext)))
        }
    }
}
