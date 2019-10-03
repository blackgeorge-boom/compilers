#include <iostream>

void foo(int y[], int z[10])
{
	y[2] = 1;
    z[3] = 1;
}

int main()
{
	int x[10];
	x[2] = 0;
    x[3] = 0;
    std::cout << x[2] << std::endl;
	foo(x, x);
	std::cout << x[3] << std::endl;
}
