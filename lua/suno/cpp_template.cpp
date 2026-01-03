#include <bits/stdc++.h>
using namespace std;

using ll = long long;
using ull = unsigned long long;
using vi = vector<int>;
using vii = vector<vector<int>>;
using pii = pair<int, int>;
using pll = pair<long long, long long>;

constexpr int inf = 1e9;
constexpr int max_n = 1e5 + 5;
constexpr int mod = 1e9 + 7;

#define F first
#define S second
#define PB push_back
#define MP make_pair

#define SZ(x) ((int)(x).size())
#define SQ(x) ((x) * (x))
#define CU(x) ((x) * (x) * (x))

#define DEB(x) cout << #x << " = " << x << endl
#define DEB2(x, y) cout << #x << " = " << x << ", " << #y << " = " << y << endl

#define DEBARR(arr, n)                                                         \
  cout << #arr << " : ";                                                       \
  for (int i = 0; i < n; i++)                                                  \
    cout << arr[i] << " ";                                                     \
  cout << endl

#define DEBVEC(v)                                                              \
  cout << #v << " : ";                                                         \
  for (auto x : v)                                                             \
    cout << x << " ";                                                          \
  cout << endl

#define DEBMAP(m)                                                              \
  cout << #m << " : ";                                                         \
  for (auto &[k, v] : m)                                                       \
    cout << "{" << k << " -> " << v << "} ";                                   \
  cout << endl

#define FASTIO                                                                 \
  ios::sync_with_stdio(0);                                                     \
  cin.tie(0);                                                                  \
  cout.tie(0);

#define REP(i, x, y) for (int i = (x); i <= (y); ++i)

#define REPR(i, x, y) for (int i = (x); i >= (y); --i)

struct Timer {
  chrono::high_resolution_clock::time_point start;
  Timer() { start = chrono::high_resolution_clock::now(); }
  ~Timer() {
    auto end = chrono::high_resolution_clock::now();
    cerr << "[TIME]: "
         << chrono::duration_cast<chrono::milliseconds>(end - start).count()
         << " ms\n";
  }
};

#define timed(x)                                                               \
  {                                                                            \
    Timer __t;                                                                 \
    x;                                                                         \
  }

void solve() {
  // Author: https://prerit714.cloud
}

int main() {
  FASTIO;
  timed({ solve(); });
  return EXIT_SUCCESS;
}
