
#ifndef InlineDiffJSON_hpp
#define InlineDiffJSON_hpp

#include <stdio.h>

#include "Wikidiff2.h"
#include <string>
#include <sstream>

enum DiffType {Context, Change};
enum HighlightType {Add, Delete};

class InlineDiffJSON: public Wikidiff2 {
public:
    bool hasResults = false;
protected:
    void printAdd(const String& line);
    void printDelete(const String& line);
    void printAddDelete(const String& line, HighlightType highlightType);
    void printWordDiff(const String& text1, const String& text2, bool printLeft = true, bool printRight = true, const String & srcAnchor = "", const String & dstAnchor = "", bool moveDirectionDownwards = false);
    void printBlockHeader(int leftLine, int rightLine);
    void printContext(const String& input);
    std::string escape_json(const std::string &s);
    
    void printWrappedLine(const char* pre, const String& line, const char* post);
};

#endif /* InlineDiffJSON_hpp */
