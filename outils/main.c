#include <stdlib.h>
#include <stdio.h>

#define MAX 50
#define QTY 10000

int main(void) {
  int n = QTY;
  printf("[");
  while (n > 0) {
    int x = rand() % (MAX + 1);
    int y = rand() % (MAX + 1);
    printf("[%f; %f]", x / (float) MAX, y / (float) MAX);
    --n;
    if (n > 0) {
      printf("; ");
    } else {
      printf("]");
    }
  }
  return EXIT_SUCCESS;
}
