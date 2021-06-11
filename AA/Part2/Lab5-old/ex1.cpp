#include <bits/stdc++.h>
using namespace std;

typedef pair <double, double> Pct;

int CCW(Pct x, Pct y, Pct z)
{
    y.first -= x.first;
    y.second -= x.second;
    z.first -= x.first;
    z.second -= x.second;

    return y.first * z.second - y.second * z.first;
}

int main()
{
    Pct P, Q, R;
    cin >> P.first >> P.second;
    cin >> Q.first >> Q.second;
    cin >> R.first >> R.second;

    double ccw = CCW(P, Q, R);

    if (abs(ccw) < 1e-6)
        cout << "Puncte coliniare!\n";
    else if (ccw < 0)
        cout << "Viraj dreapta!\n";
    else
        cout << "Viraj stanga!\n";
}
