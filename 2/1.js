const answer = require("fs")
    .readFileSync("in", "utf8")
    .split("\n")
    .filter(line => line != "")
    .map(line => {
        let [amount, character, password] = line.split(" ")
        const [min, max] = amount.split("-")
        character = character[0]
        return { min, max, character, password }
    })
    .filter(({ min, max, character, password }) => {
        const occurances = [...password].filter(c => c == character).length
        return min <= occurances && occurances <= max
    })
    .length

console.log(answer)
