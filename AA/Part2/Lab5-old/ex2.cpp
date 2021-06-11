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

vector <Pct> acoperire(vector <Pct> puncte)
{
    int p_min = 0;

    for (int i = 1; i < (int)puncte.size(); i++)
        if (puncte[i] < puncte[p_min])
            p_min = i;
    
    rotate(puncte.begin(), puncte.begin() + p_min, puncte.end());

    vector <Pct> rez;

    for (auto p : puncte) {
        while (rez.size() >= 2 && CCW(rez[rez.size() - 2], rez.back(), p) <= 0)
            rez.pop_back();
        
        rez.push_back(p);
    }

    while (rez.size() >= 3 && CCW(rez[rez.size() - 2], rez.back(), rez[0]) <= 0)
        rez.pop_back();

    return rez;
}

int main()
{
    int n;
    cout << "Cate puncte? ";
    cin >> n;
    vector <Pct> puncte(n);
    
    for (auto& [x, y] : puncte)
        cin >> x >> y;

    cout << "Acoperire convexa:\n";

    for (auto [x, y] : acoperire(puncte))
        cout << " " << x << ' ' << y << "\n";
}