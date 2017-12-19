#include "rpn.h"

#include <cstdio>
#include <cctype>
#include <cstdlib>



int main(int argc, char const *argv[])
{
  int c;
  int op2, op1;
  puts("Enter expressions");

  while( (c=token() ) != EOF ){
    switch(c){
      case NUM:
      push(atoi(buf));
      break;

      case '+':
      if(size()>= 2){
        op2 = pop(), op1= pop();
        push(op1+op2);
        printf(" ++++++++++ \n");

      } else{
        printf("dc: stack empty \n");
      }
      break;

      case '-':
      if(size()>= 2){
        op2 = pop(), op1= pop();
        push(op1-op2);
        printf(" ---------- \n");
      } else{
        printf("dc: stack empty \n");
      }
      break;

      case '*':
      if(size()>= 2){
        op2 = pop(), op1= pop();
        push(op1*op2);
        printf(" ********** \n");
      } else{
        printf("dc: stack empty \n");
      }
      break;

      case '/':
      if(size()>= 2){
        op2 = pop(), op1= pop();
        printf(" ////////// \n");
        push(op1/op2);
        
      } else{
        printf("dc: stack empty \n");
      }
      break;

      case 'p':
      printf( is_empty() ? "dc: stack empty\n" : "%d\n", top() );
      break;

      default:
      break;
    }
  }

  return 0;
}


int token(){
  int c = getchar();

  if(isdigit(c)){
    buf[cnt++] =c;
    while((c = getchar()) != EOF) {
      if(isdigit(c)){
        buf[cnt++] = c;
      }else {
        buf[cnt]='\0'; //
        cnt = 0;
        ungetc(c, stdin);
        return NUM;
      }
    }
  } else{
    return c;
  }
}

void push(int item){
  if(!is_full() ){
    stack[sp++] = item;
  }
}


int pop(){
  if( !is_empty()){
    return stack[--sp];
  }
}

int top(){
  if(!is_empty()){
    return stack[sp-1];
  }

}


int is_full(){
  return sp >= ST_LEN;
}

int is_empty(){
  return sp <=0;
}

int size(){
  return sp;
}


void clear(){
  sp=0;
}




 