
#ifndef DiffHandler_hpp
#define DiffHandler_hpp

#include <stdio.h>
#include <string>

class DiffHandler {
public:
    DiffHandler();
    std::string diff(const std::string & text1, const std::string & text2);
};

#endif /* DiffHandler_hpp */
