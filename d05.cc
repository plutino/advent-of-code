#include <iostream>
#include <vector>

#include "d05d.cc"

using namespace std;

int p1(const vector<int> & initial_maze){
  vector<int> maze(initial_maze);
  int step = 0;
  vector<int>::iterator it = maze.begin();

  while (it >= maze.begin() && it < maze.end()) {
    it += (*it)++;
    ++step;
  }
  return step;
}

int p2(const vector<int> & initial_maze){
  vector<int> maze(initial_maze);
  int step = 0;
  vector<int>::iterator it = maze.begin();

  while (it >= maze.begin() && it < maze.end()) {
    it += (*it < 3 ? (*it)++ : (*it)--);
    ++step;
  }
  return step;
}

int main(){
  cout << p1(initial_maze) << endl;
  cout << p2(initial_maze) << endl;
}