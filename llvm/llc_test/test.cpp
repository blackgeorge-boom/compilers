#include <iostream>

int foo(int x)
{
	if (x) return 0;
	else return 1;
}

int main()
{
	int x;
	x = 0;
	foo(x);
}
