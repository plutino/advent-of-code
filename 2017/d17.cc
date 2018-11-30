#include <iostream>

using namespace std;

struct ListNode {
  int val;
  ListNode *next;

  ListNode(int v):val(v){};

  void insert(int v) {
    ListNode *new_node = new ListNode(v);
    new_node->next = next;
    next = new_node;
  }
};

class CircularList {
  ListNode *head;
  ListNode *cur;

public:

  // construct a circular list with a value for the head node
  CircularList(int val) {
    head = new ListNode(val);
    head -> next = head;
    cur = head;
  }

  ~CircularList() {
    clear();
    delete head;
  }

  ListNode * first() {
    return head;
  }

  ListNode * current() {
    return cur;
  }

  ListNode * skip(int length) {
    for (int j = 0; j < length; ++j) cur = cur->next;
    return cur;
  }

  // remove all nodes except the head nodes
  void clear() {
    cur = head-> next;
    while (cur != head) {
      ListNode *tmp = cur;
      cur = cur->next;
      delete tmp;
    }
    head->next = head;
  }
};

int main(int argc, char* argv[]){
  int hops = atoi(argv[1]);

  CircularList list(0);

  // Part 1
  for (int i = 1; i <= 2017; ++i) {
    list.skip(hops)->insert(i);
    list.skip(1);
  }

  cout << "Answer to Part 1: " << list.current()->next->val << endl;

  list.clear();
  for (int i = 1; i <= 50000000; ++i) {
    list.skip(hops)->insert(i);
    list.skip(1);
  }

  cout << "Answer to Part 2: " << list.first()->next->val << endl;
}
