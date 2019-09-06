
#include "InlineDiffJSON.hpp"
#include <string>
#include <sstream>
#include <iomanip>

void InlineDiffJSON::printAdd(const String& line)
{
    printAddDelete(line, HighlightType::Add);
}

void InlineDiffJSON::printDelete(const String& line)
{
    printAddDelete(line, HighlightType::Delete);
}

void InlineDiffJSON::printAddDelete(const String& line, HighlightType highlightType) {
    if (hasResults)
        result += ",";
    
    const char* pre;
    String escapedLine;
    int diffType = DiffType::Change;
    
    std::string preString = "{\"type\": " + std::to_string(diffType) + ", \"text\": ";
    pre = preString.c_str();
    
    if(line.empty()) {
        std::string strPost = ", \"highlightRanges\": [{\"start\": 0, \"length\": 1, \"type\": " + std::to_string(highlightType) + "}]}";
        escapedLine = "\" \"";
        printWrappedLine(pre, escapedLine, strPost.c_str());
    } else {
        std::stringstream highlightRanges;
        highlightRanges << ", \"highlightRanges\": [{\"start\": 0, \"length\": " << line.length() << ", \"type\": " << highlightType << "}]}";
        escapedLine = "\"" + escape_json(line) + "\"";
        printWrappedLine(pre, escapedLine, highlightRanges.str().c_str());
    }
    
    hasResults = true;
}

void InlineDiffJSON::printWordDiff(const String& text1, const String& text2, bool printLeft, bool printRight, const String & srcAnchor, const String & dstAnchor, bool moveDirectionDownwards)
{
    WordVector words1, words2;
    
    TextUtil::explodeWords(text1, words1);
    TextUtil::explodeWords(text2, words2);
    WordDiff worddiff(words1, words2, MAX_WORD_LEVEL_DIFF_COMPLEXITY);
    String word;
    std::string diffType = std::to_string(DiffType::Change);
    
    bool moved = printLeft != printRight,
    isMoveSrc = moved && printLeft;
    
    if (hasResults)
        result += ",";
    if (moved) {
        if (isMoveSrc) {
            result += "{\"type\": " + diffType + ", \"moveID\": \"" + srcAnchor + "\", \"movedToID\": \"" + dstAnchor + "\", \"text\": \"";
        } else {
            result += "{\"type\": " + diffType + ", \"moveID\": \"" + dstAnchor + "\", \"movedFromID\": \"" + srcAnchor + "\", \"text\": \"";
        }
    } else {
        result += "{\"type\": " + diffType + ", \"text\": \"";
    }
    hasResults = true;
    
    String rangeCalcResult;
    String ranges = "[";
    for (unsigned i = 0; i < worddiff.size(); ++i) {
        DiffOp<Word> & op = worddiff[i];
        unsigned long n;
        int j;
        if (op.op == DiffOp<Word>::copy) {
            n = op.from.size();
            for (j=0; j<n; j++) {
                op.from[j]->get_whole(word);
                rangeCalcResult += word;
                printText(escape_json(word), true);
            }
        } else if (op.op == DiffOp<Word>::del) {
            n = op.from.size();
            for (j=0; j<n; j++) {
                op.from[j]->get_whole(word);
                
                std::stringstream positionStream;
                positionStream  << "" << rangeCalcResult.length() << "";
                std::stringstream lengthStream;
                lengthStream << "" << word.length() << "";
                if (ranges.length() > 1)
                    ranges += ",";
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": " + std::to_string(HighlightType::Delete) + " }";
                rangeCalcResult += word;
                
                printText(escape_json(word), true);
            }
        } else if (op.op == DiffOp<Word>::add) {
            if (isMoveSrc)
                continue;
            n = op.to.size();
            //result += "<ins>";
            for (j=0; j<n; j++) {
                op.to[j]->get_whole(word);
                
                std::stringstream positionStream;
                positionStream  << "" << rangeCalcResult.length() << "";
                std::stringstream lengthStream;
                lengthStream << "" << word.length() << "";
                if (ranges.length() > 1)
                    ranges += ",";
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": " + std::to_string(HighlightType::Add) + " }";
                rangeCalcResult += word;
                
                printText(escape_json(word), true);
            }
            //result += "</ins>";
        } else if (op.op == DiffOp<Word>::change) {
            n = op.from.size();
            for (j=0; j<n; j++) {
                op.from[j]->get_whole(word);
                
                std::stringstream positionStream;
                positionStream  << "" << rangeCalcResult.length() << "";
                std::stringstream lengthStream;
                lengthStream << "" << word.length() << "";
                if (ranges.length() > 1)
                    ranges += ",";
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": " + std::to_string(HighlightType::Delete) + " }";
                rangeCalcResult += word;
                
                printText(escape_json(word), true);
            }
            if (isMoveSrc)
                continue;
            n = op.to.size();
            for (j=0; j<n; j++) {
                op.to[j]->get_whole(word);
                
                std::stringstream positionStream;
                positionStream  << "" << rangeCalcResult.length() << "";
                std::stringstream lengthStream;
                lengthStream << "" << word.length() << "";
                if (ranges.length() > 1)
                    ranges += ",";
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": " + std::to_string(HighlightType::Add) + " }";
                rangeCalcResult += word;
                
                printText(escape_json(word), true);
            }
            
            //remove trailing comma in ranges
            
        }
    }
    result += "\", \"highlightRanges\": " + ranges + "]}";
}

void InlineDiffJSON::printBlockHeader(int leftLine, int rightLine)
{
    //inline diff json not setup to print this
}

void InlineDiffJSON::printContext(const String & input)
{
    if (hasResults)
        result += ",";
    
    const char* pre;
    std::string preString = "{\"type\": " + std::to_string(DiffType::Context) + ", \"text\": ";
    pre = preString.c_str();
    
    printWrappedLine(pre, "\"" + escape_json(input) + "\"", ", \"highlightRanges\": []}");
    hasResults = true;
}

void InlineDiffJSON::printWrappedLine(const char* pre, const String& line, const char* post)
{
    result += pre;
    if (line.empty()) {
        result += " ";
    } else {
        printText(line, true);
    }
    result += post;
}

std::string InlineDiffJSON::escape_json(const std::string &s) {
    std::ostringstream o;
    for (auto c = s.cbegin(); c != s.cend(); c++) {
        switch (*c) {
            case '"': o << "\\\""; break;
            case '\\': o << "\\\\"; break;
            case '\b': o << "\\b"; break;
            case '\f': o << "\\f"; break;
            case '\n': o << "\\n"; break;
            case '\r': o << "\\r"; break;
            case '\t': o << "\\t"; break;
            default:
                if ('\x00' <= *c && *c <= '\x1f') {
                    o << "\\u"
                    << std::hex << std::setw(4) << std::setfill('0') << (int)*c;
                } else {
                    o << *c;
                }
        }
    }
    return o.str();
}
