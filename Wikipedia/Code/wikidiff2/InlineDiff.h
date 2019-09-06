#ifndef INLINEDIFF_H
#define INLINEDIFF_H

#include "Wikidiff2.h"

class InlineDiff: public Wikidiff2 {
	public:
	protected:
		void printAdd(const String& line, const String& sectionTitle);
		void printDelete(const String& line, const String& sectionTitle);
		void printWordDiff(const String& text1, const String& text2, const String& sectionTitle, bool printLeft = true, bool printRight = true, const String & srcAnchor = "", const String & dstAnchor = "", bool moveDirectionDownwards = false);
		void printBlockHeader(int leftLine, int rightLine);
		void printContext(const String& input, const String& sectionTitle);

		void printWrappedLine(const char* pre, const String& line, const char* post);
};

#endif
