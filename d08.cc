#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>

using namespace std;

typedef map<string, int> Registry;

struct Cond {
  string reg;
  string op;
  int val;

  Cond(const string & r, const string & o, int v)
    : reg(r), op(o), val(v) {};

  bool eval(const Registry & registry) const {
    if (op == "==") return registry.find(reg)->second == val;
    else if (op == "!=") return registry.find(reg)->second != val;
    else if (op == ">") return registry.find(reg)->second > val;
    else if (op == ">=") return registry.find(reg)->second >= val;
    else if (op == "<") return registry.find(reg)->second < val;
    else if (op == "<=") return registry.find(reg)->second <= val;
    else return false;
  }
};

struct Inst {
  string reg;
  int inc;
  Cond cond;

  Inst(const string & r, int i, const string & cond_r, const string & cond_op, int cond_v)
    :reg(r), inc(i), cond(cond_r, cond_op, cond_v){};
};

void parse_data(vector<Inst> & instructions, const string & file){
  ifstream ifs(file);

  while (!ifs.eof()) {
    string reg, sign, cond_reg, cond_op, tmpstr;
    int inc, cond_val;
    ifs >> reg >> sign >> inc >> tmpstr >> cond_reg >> cond_op >> cond_val;
    if (sign == "dec") inc *= -1;
    instructions.push_back(Inst(reg, inc, cond_reg, cond_op, cond_val));
  }
}

bool registry_cmp(const pair<string, int> & a, const pair<string, int> & b){
  return a.second < b.second;
}

int p1(const vector<Inst> & instructions){
  Registry registry;

  for (vector<Inst>::const_iterator it = instructions.begin(); it != instructions.end(); ++it) {
    if (registry.find(it->reg) == registry.end()) registry[it->reg] = 0;
    if (registry.find(it->cond.reg) == registry.end()) registry[it->cond.reg] = 0;
    if (it->cond.eval(registry)) registry[it->reg] += it->inc;
  }
  return max_element(registry.begin(), registry.end(), registry_cmp)->second;
}

int p2(const vector<Inst> & instructions){
  Registry registry;
  int largest = 0;

  for (vector<Inst>::const_iterator it = instructions.begin(); it != instructions.end(); ++it) {
    if (registry.find(it->reg) == registry.end()) registry[it->reg] = 0;
    if (registry.find(it->cond.reg) == registry.end()) registry[it->cond.reg] = 0;
    if (it->cond.eval(registry)) {
      registry[it->reg] += it->inc;
      if (registry[it->reg] > largest) largest = registry[it->reg];
    }
  }
  return largest;
}

int main(int argc, char* argv[]){
  vector<Inst> instructions;

  parse_data(instructions, string(argv[1]));
  cout << "p1: " << p1(instructions) << endl;
  cout << "p2: " << p2(instructions) << endl;
}
