
#include "InlineDiffJSON.hpp"
#include <string>
#include <sstream>

void InlineDiffJSON::printAdd(const String& line)
{
    if (!noResults)
        result += ",";
    if(line.empty()) {
        printWrappedLine("{\"type\": \"add\", \"text\": ", "\"" + line + "\"", ", \"highlight-ranges\": [{\"start\": 0, \"length\": 1, \"type\": \"add\"}]}");
    } else {
        std::stringstream highlightRanges;
        highlightRanges << ", \"highlight-ranges\": [{\"start\": 0, \"length\": " << line.length() << ", \"type\": \"add\"}]}";
        printWrappedLine("{\"type\": \"add\", \"text\": ", "\"" + line + "\"", highlightRanges.str().c_str());
    }
    noResults = false;
}

void InlineDiffJSON::printDelete(const String& line)
{
    if (!noResults)
        result += ",";
    if(line.empty()) {
        printWrappedLine("{\"type\": \"delete\", \"text\": ", "\"" + line + "\"", ", \"highlight-ranges\": [{\"start\": 0, \"length\": 1, \"type\": \"delete\"}]}");
    } else {
        std::stringstream highlightRanges;
        highlightRanges << ", \"highlight-ranges\": [{\"start\": 0, \"length\": " << line.length() << ", \"type\": \"delete\"}]}";
        printWrappedLine("{\"type\": \"delete\", \"text\": ", "\"" + line + "\"", highlightRanges.str().c_str());;
    }
    noResults = false;
}

void InlineDiffJSON::printWordDiff(const String& text1, const String& text2, bool printLeft, bool printRight, const String & srcAnchor, const String & dstAnchor, bool moveDirectionDownwards)
{
    WordVector words1, words2;
    
    TextUtil::explodeWords(text1, words1);
    TextUtil::explodeWords(text2, words2);
    WordDiff worddiff(words1, words2, MAX_WORD_LEVEL_DIFF_COMPLEXITY);
    String word;
    
    bool moved = printLeft != printRight,
    isMoveSrc = moved && printLeft;
    
    if (!noResults)
        result += ",";
    if (moved) {
        if (isMoveSrc) {
            result += "{\"type\": \"change\", \"moveID\": \"" + srcAnchor + "\", \"movedToID\": \"" + dstAnchor + "\", \"text\": \"";
        } else {
            result += "{\"type\": \"change\", \"moveID\": \"" + dstAnchor + "\", \"movedFromID\": \"" + srcAnchor + "\", \"text\": \"";
        }
    } else {
        result += "{\"type\": \"change\", \"text\": \"";
    }
    noResults = false;
    
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
                printText(word);
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
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": \"delete\" }";
                rangeCalcResult += word;
                
                printText(word);
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
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": \"add\" }";
                rangeCalcResult += word;
                
                printText(word);
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
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": \"delete\" }";
                rangeCalcResult += word;
                
                printText(word);
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
                ranges += "{\"start\": " + positionStream.str() + ", \"length\": " + lengthStream.str() + ", \"type\": \"add\" }";
                rangeCalcResult += word;
                
                printText(word);
            }
            
            //remove trailing comma in ranges
            
        }
    }
    result += "\", \"highlight-ranges\": " + ranges + "]}";
}

void InlineDiffJSON::printBlockHeader(int leftLine, int rightLine)
{
    //inline diff json not setup to print this
}

void InlineDiffJSON::printContext(const String & input)
{
    if (!noResults)
        result += ",";
    printWrappedLine("{\"type\": \"context\", \"text\": ", "\"" + input + "\"", ", \"highlight-ranges\": []}");
    noResults = false;
}

void InlineDiffJSON::printWrappedLine(const char* pre, const String& line, const char* post)
{
    result += pre;
    if (line.empty()) {
        result += "&#160;";
    } else {
        printText(line);
    }
    result += post;
}
