#include <iostream>
#include <set>
#include <vector>
#include <map>
#include <algorithm>

using namespace std;

const int init_v[] = { 10, 3, 15, 10, 5, 15, 5, 15, 9, 2, 5, 8, 5, 2, 3, 6 };
const vector<int> initial_banks(init_v, init_v + sizeof(init_v)/sizeof(int));

int p1(const vector<int> & initial_banks) {
  vector<int> banks(initial_banks);
  set< vector<int> > snapshots;

  int count = 0;
  while (snapshots.find(banks) == snapshots.end()) {
    snapshots.insert(banks);
    vector<int>::iterator it = max_element(banks.begin(), banks.end());
    int blocks = *it;
    *(it++) = 0;
    while (blocks-- > 0) {
      if (it == banks.end()) it = banks.begin();
      (*(it++))++;
    }
    count++;
  }
  return count;
}

int p2(const vector<int> & initial_banks) {
  vector<int> banks(initial_banks);
  map< vector<int>, int> snapshots;

  int count = 0;
  while (snapshots.find(banks) == snapshots.end()) {
    snapshots.insert(pair< vector<int>, int>(banks, count));
    vector<int>::iterator it = max_element(banks.begin(), banks.end());
    int blocks = *it;
    *(it++) = 0;
    while (blocks-- > 0) {
      if (it == banks.end()) it = banks.begin();
      (*(it++))++;
    }
    count++;
  }
  return count - snapshots[banks];
}

int main(){
  cout << p1(initial_banks) << "\n";
  cout << p2(initial_banks) << "\n";
}
