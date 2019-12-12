#include <iostream>

int factorial (int x, int y){
    if (x==0)
        return y;
    else
        return factorial(x-1,y*x);
}

int main()
{
    int x = factorial(5, 1);
	return 0;
}
