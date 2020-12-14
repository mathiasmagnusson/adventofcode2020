input = { 0 }

for line in io.lines("in") do
    input[#input+1] = tonumber(line)
end

table.sort(input)

ones = 0
threes = 1
for i = 2, #input do
    diff = input[i] - input[i - 1]
    if diff == 1 then
        ones = ones + 1
    elseif diff == 3 then
        threes = threes + 1
    end
end

print(ones * threes)
