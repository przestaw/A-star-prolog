% example grid
succ(a, a-b, 2, b).
succ(a, a-c, 3, c).
succ(b, b-g, 4, g).
succ(b, b-f, 3, f).
succ(c, c-d, 2, d).
succ(c, c-e, 3, e).
succ(g, g-m, 2, m).
succ(f, f-h, 4, h).
succ(d, d-m, 2, m).
succ(e, e-m, 5, m).

% set goal
goal(m).

% basic heuristic
hScore(a, 4).
hScore(b, 4).
hScore(c, 3).
hScore(d, 1).
hScore(e, 4).
hScore(f, 7).
hScore(g, 1).
hScore(h, 3).
hScore(m, 0).
