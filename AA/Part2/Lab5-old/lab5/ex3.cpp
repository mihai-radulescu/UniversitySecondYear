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

auto check_p_line(const vector <Pct>& v, Pct p){
    int id = 0;
        
        for (int pas = 1, cresc = 1; pas; pas = (cresc ? 2 * pas : pas / 2)) {
            int new_id = id + pas;
            
            if (new_id + 1 < (int)v.size() && v[new_id].first <= p.first)
                id = new_id;
            else
                cresc = 0;
        }

        double ccw = CCW(v[id], v[id + 1], p);
        if (abs(ccw) < 1e-6)
            return 0;
        if (ccw > 0)
            return 1;
        return -1;
}

int main()
{
   int n;
    cout << "Nr de puncte: ";
    cin >> n;

    vector <Pct> v(n);
    for (auto& [a, b] : v)
        cin >> a >> b;

    int p_min = 0, p_max = 0;
    for (int i = 1; i < n; i++) {
        if (v[i] < v[p_min])
            p_min = i;
        if (v[i] > v[p_max])
            p_max = i;
    }

    vector <Pct> lower, upper;
    for (int i = p_min; i != p_max; i = (i + 1) % n)
        lower.push_back(v[i]);
    for (int i = p_max; i != p_min; i = (i + 1) % n)
        upper.push_back(v[i]);
    lower.push_back(v[p_max]);
    upper.push_back(v[p_min]);

    reverse(upper.begin(), upper.end());
    

    Pct p;
    cout << "Punctul care este verificat: ";
    cin >> p.first >> p.second;

    if (lower[0].first > p.first || lower.back().first < p.first){

        cout << "Punctul este inafara!\n";
        return 0;
    }

    int up = check_p_line(upper, p);
    int lo = check_p_line(lower, p);

    if (up == 0 || lo == 0)
        cout << "Punctul este pe poligon\n";
    
    else if (up == 1 || lo == -1)
        cout << "Punctul este inafara!\n";
    
    else cout << "Punctul este in poligon\n";
}
