input = {0}

for line in io.lines("in") do
    input[#input+1] = tonumber(line)
end

table.sort(input)

function arrangements(from)
    if from == #input then
        return 1
    end
    local i = from + 1
    local ans = 0
    while i <= #input and input[i] - input[from] <= 3 do
        ans = ans + arrangements(i)
        i = i + 1
    end
    return ans
end

arrangements = {1}
for i = 2, #input do
    local j = i - 1
    arr = 0
    while j > 0 and input[j] + 3 >= input[i] do
        arr = arr + arrangements[j]
        j = j - 1
    end
    arrangements[i] = arr
end

print(arrangements[#input])
