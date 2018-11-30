#include <iostream>
#include <vector>

#include "d05d.cc"

using namespace std;

int p1(vector<int> maze){
  int step = 0;
  for (vector<int>::iterator it = maze.begin(); it >= maze.begin() && it < maze.end(); ++step) {
    it += (*it)++;
  }
  return step;
}

int p2(vector<int> maze){
  int step = 0;
  for (vector<int>::iterator it = maze.begin(); it >= maze.begin() && it < maze.end(); ++step) {
    it += (*it < 3 ? (*it)++ : (*it)--);
  }
  return step;
}

int main(){
  cout << p1(initial_maze) << endl;
  cout << p2(initial_maze) << endl;
}