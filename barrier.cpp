#include "./barrier.hpp"

// barrier::barrier(size_t expected)
//     :_expected(expected)
//     ,_arrived(0)
//     ,_passed(0)
// {
//     // 
// }

void
barrier::arrive_and_wait()
{
    size_t _passed_expected = _passed.load();
    if (_arrived.fetch_add(1) == _expected - 1) {
        _arrived.store(0);
        _passed.fetch_add(1);
    } else {
        while(_passed.load() == _passed_expected) {
            //busy wait
        }
    }
}
