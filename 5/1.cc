#include <fstream>
#include <iostream>

using namespace std;

int main() {
    ifstream input;
    input.open("in");

    int max_id = 0;
    string seat;
    while (input >> seat) {
        int from = 0, to = 128;
        int i;
        for (i = 0; i < 7; i++) {
            int mid = (from + to) / 2;
            if (seat[i] == 'F') to = mid;
            else if (seat[i] == 'B') from = mid;
        }
        int row = from;

        from = 0, to = 8;
        for (; i < 10; i++) {
            int mid = (from + to) / 2;
            if (seat[i] == 'L') to = mid;
            if (seat[i] == 'R') from = mid;
        }
        int col = from;

        int id = row * 8 + col;

        max_id = max(max_id, id);
    }

    cout << max_id << endl;
}
