const answer = require("fs")
    .readFileSync("in", "utf8")
    .split("\n")
    .filter(line => line != "")
    .map(line => {
        let [amount, character, password] = line.split(" ")
        const [a, b] = amount.split("-").map(index => parseInt(index) - 1)
        character = character[0]
        return { a, b, character, password }
    })
    .filter(({ a, b, character, password }) =>
        (password[a] === character) != (password[b] === character)
    )
    .length

console.log(answer)
