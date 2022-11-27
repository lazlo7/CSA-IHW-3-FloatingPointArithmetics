#include <stdio.h>

double func(double a, double b, double x) {
    return a + b / (x * x);
}

double simpson_approximate(double a, double b) {
    return (b - a) / 6 * (func(a, b, a) + 4 * func(a, b, (a + b) / 2) + func(a, b, b));
}

int main() {
    double a, b;

    printf("Enter a and b (a <= b): \n");
    scanf("%lf", &a);
    scanf("%lf", &b);

    if (a > b) {
        printf("Error: a must be less than or equal to b\n");
        return 1;
    }

    if (a == 0 || b == 0) {
        printf("Error: a and b must not be equal to 0\n");
        return 1;
    }

    printf("Result: %lf\n", simpson_approximate(a, b));

    return 0;
}