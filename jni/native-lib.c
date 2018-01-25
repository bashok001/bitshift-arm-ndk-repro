#include <stdio.h>

typedef struct Oops {
    long long state;
} oops;

void bugRepro(oops *oops) {
    long long state = oops->state;

    state += 1300771L;
    state ^= (state << 13);

    oops->state = state;
}

int main(int argc, char const *argv[]) {
    volatile oops a;

    a.state = -10;
    printf("Initial State: %lld\n", a.state);

    bugRepro((oops *)&a);
    printf("TEST State: %lld\n", a.state);
    return 0;
}
