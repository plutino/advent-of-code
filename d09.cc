#include <iostream>
#include <fstream>
#include <string>

using namespace std;

void process(const string & file, int & score, int & garbage_ct){
  ifstream ifs(file);

  bool in_garbage = false;
  bool in_negate = false;
  int level = score = garbage_ct = 0;

  for (char ch; ifs >> ch;) {
    if (in_negate) in_negate = false;
    else if (in_garbage) {
      if (ch == '!') in_negate = true;
      else if (ch == '>') in_garbage = false;
      else ++garbage_ct;
    } else {
      switch (ch) {
        case '{': level += 1; break;
        case '}': score += level; level -= 1; break;
        case '<': in_garbage = true;
      }
    }
  }
}

int main(int argc, char * argv[]) {
  int score, garbage_ct;
  process(argv[1], score, garbage_ct);
  cout << "group score: " << score << endl << "garbage count: " << garbage_ct << endl;
}
