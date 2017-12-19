#define ST_LEN 1024 //the depth of stack
#define BUF_SIZE 32
#define NUM '0'

void push(int);
int pop();
int top();
int is_empty();
int is_full();
int size();
void clear();
//private form stack.c
int stack[ST_LEN];
int sp = 0; //point to next empty space
 
//public form main.h
int token();
//public form main.c
char buf[BUF_SIZE];
int cnt = 0;