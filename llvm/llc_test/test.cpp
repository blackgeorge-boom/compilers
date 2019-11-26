#include <iostream>
int foo()
{
	if (0) return 0;
	else return 1;
}


int main()
{
	int j = 0;
	for (int i = 0; i < 10; ++i) {
        j = i * 10;
        std::cout << j << std::endl;
	}

	return j;
}
