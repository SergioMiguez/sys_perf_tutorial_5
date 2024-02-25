#include <cstddef>
#include <atomic>

class barrier {
public:
    barrier(size_t expected)
        :_expected(expected)
        ,_arrived(0)
        ,_passed(0)
        {}

    void arrive_and_wait();

private:
    const size_t _expected;
    std::atomic<size_t> _arrived;
    std::atomic<size_t> _passed;
};

// void barrier::arrive_and_wait();
//  {
//     size_t _passed_expected = _passed.load();
//     if (_arrived.fetch_add(1) == _expected - 1) {
//         _arrived = 0;
//         _passed++;
//     } else {
//         while(_passed.load() == _passed_expected) {
//             //busy wait
//         }
//     }
// }