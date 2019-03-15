import Foundation

@objc(WMFMediaWikiFetcher)
open class MediaWikiFetcher: Fetcher {
    @discardableResult public func requestMediaWikiAPIAuthToken(for URL: URL?, type: TokenType, cancellationKey: CancellationKey? = nil, completionHandler: @escaping (FetcherResult<Token, Error>) -> Swift.Void) -> URLSessionTask? {
        let parameters = [
            "action": "query",
            "meta": "tokens",
            "type": type.stringValue,
            "format": "json"
        ]
        return performMediaWikiAPIPOST(for: URL, with: parameters) { (result, response, error) in
            if let error = error {
                completionHandler(FetcherResult.failure(error))
                return
            }
            guard
                let query = result?["query"] as? [String: Any],
                let tokens = query["tokens"] as? [String: Any],
                let tokenValue = tokens[type.stringValue + "token"] as? String
                else {
                    completionHandler(FetcherResult.failure(RequestError.unexpectedResponse))
                    return
            }
            guard !tokenValue.isEmpty else {
                completionHandler(FetcherResult.failure(RequestError.unexpectedResponse))
                return
            }
            completionHandler(FetcherResult.success(Token(value: tokenValue, type: type)))
        }
    }
    
    
    @objc(requestMediaWikiAPIAuthToken:withType:cancellationKey:completionHandler:)
    @discardableResult public func requestMediaWikiAPIAuthToken(for URL: URL?, with type: TokenType, cancellationKey: CancellationKey? = nil, completionHandler: @escaping (Token?, Error?) -> Swift.Void) -> URLSessionTask? {
        return requestMediaWikiAPIAuthToken(for: URL, type: type, cancellationKey: cancellationKey) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(nil, error)
            case .success(let token):
                completionHandler(token, nil)
            }
        }
    }
    
    @objc(performTokenizedMediaWikiAPIPOSTWithTokenType:toURL:withBodyParameters:cancellationKey:completionHandler:)
    @discardableResult public func performTokenizedMediaWikiAPIPOST(tokenType: TokenType = .csrf, to URL: URL?, with bodyParameters: [String: String]?, cancellationKey: CancellationKey? = nil, completionHandler: @escaping ([String: Any]?, HTTPURLResponse?, Error?) -> Swift.Void) -> CancellationKey? {
        let key = cancellationKey ?? UUID().uuidString
        let task = requestMediaWikiAPIAuthToken(for: URL, type: tokenType, cancellationKey: key) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(nil, nil, error)
                self.untrack(taskFor: key)
            case .success(let token):
                var mutableBodyParameters = bodyParameters ?? [:]
                mutableBodyParameters[tokenType.parameterName] = token.value
                self.performMediaWikiAPIPOST(for: URL, with: mutableBodyParameters, cancellationKey: key, completionHandler: completionHandler)
            }
        }
        track(task: task, for: key)
        return key
    }
    
    @objc(performMediaWikiAPIPOSTForURL:withBodyParameters:cancellationKey:completionHandler:)
    @discardableResult public func performMediaWikiAPIPOST(for URL: URL?, with bodyParameters: [String: String]?, cancellationKey: CancellationKey? = nil, completionHandler: @escaping ([String: Any]?, HTTPURLResponse?, Error?) -> Swift.Void) -> URLSessionTask? {
        let components = configuration.mediaWikiAPIURForHost(URL?.host)
        let key = cancellationKey ?? UUID().uuidString
        let task = session.postFormEncodedBodyParametersToURL(to: components.url, bodyParameters: bodyParameters) { (result, response, error) in
            completionHandler(result, response, error)
            self.untrack(taskFor: key)
        }
        track(task: task, for: key)
        return task
    }
    
    @objc(performMediaWikiAPIGETForURL:withQueryParameters:cancellationKey:completionHandler:)
    @discardableResult public func performMediaWikiAPIGET(for URL: URL?, with queryParameters: [String: Any]?, cancellationKey: CancellationKey?, completionHandler: @escaping ([String: Any]?, HTTPURLResponse?, Error?) -> Swift.Void) -> URLSessionTask? {
        let components = configuration.mediaWikiAPIURForHost(URL?.host, with: queryParameters)
        let key = cancellationKey ?? UUID().uuidString
        let task = session.getJSONDictionary(from: components.url) { (result, response, error) in
            completionHandler(result, response, error)
            self.untrack(taskFor: key)
        }
        track(task: task, for: key)
        return task
    }
    
    public func parseMediaWikiError(_ errorString: String, siteURL: URL, cancellationKey: CancellationKey? = nil, completion: @escaping (FetcherResult<String, Error>) -> Void) {
        let parameters: [String: String] = [
            "action": "parse",
            "text": errorString,
            "format": "json"
        ]
        performMediaWikiAPIGET(for: siteURL, with: parameters, cancellationKey: cancellationKey) { (result, response, error) in
            guard
                let parse = result?["parse"] as? [String: Any],
                let text = parse["text"] as? [String: String],
                let htmlString = text["*"]
            else {
                completion(FetcherResult.failure(RequestError.unexpectedResponse))
                return
            }
            completion(FetcherResult.success(htmlString))
        }
    }
}
