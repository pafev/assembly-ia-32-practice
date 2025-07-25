extern void input(char *, char *);
extern void process(char *, char *);
extern void output(char *);

int main() {
  char vector[25] = {0};
  char num = 0;

  input(vector, &num);
  process(vector, &num);
  output(vector);

  return 0;
}
