#include <thread>
#include <unistd.h>
#include <vector>
#include <cstdio>
#include <cstdlib> 

#include "barrier.hpp"

void work(size_t id, barrier& b)
{
    printf("+%ld\n", id); fflush(stdout);

    b.arrive_and_wait();
    usleep(100);

    printf(".%ld\n", id); fflush(stdout);

    b.arrive_and_wait();

    printf("-%ld\n", id); fflush(stdout);
}


int main(int argc, char** argv)
{
    auto nthreads = atoi(argv[1]);
    barrier b(nthreads);
    std::vector<std::thread> threads;

    for (auto i = nthreads; i; i--) {
        threads.emplace_back(work, i, std::ref(b));
    }

    for (auto& thread : threads) {
        thread.join();
    }
}
