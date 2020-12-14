with open("in", "r") as f:
    data = f.read()

data = data.split("\n")

for a in data:
    for b in data:
        try:
            a, b = int(a), int(b)
        except:
            continue

        if a + b == 2020:
            print(a * b)
