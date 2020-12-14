with open("in", "r") as f:
    data = f.read()

data = data.split("\n")

for a in data:
    for b in data:
        for c in data:
            try:
                a, b, c = int(a), int(b), int(c)
            except:
                continue

            if a + b + c == 2020:
                print(a * b * c)
