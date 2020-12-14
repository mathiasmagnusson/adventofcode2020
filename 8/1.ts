const instructions = new TextDecoder("utf8")
    .decode(await Deno.readFile("in"))
    .split("\n")

const seenLines = new Set()

let acc = 0, rip = 0
while (true) {
    if (seenLines.has(rip)) {
        console.log(acc)
        break;
    }
    seenLines.add(rip)

    let [instruction, value] = instructions[rip].split(" ")
    switch (instruction) {
        case "nop": rip++; break;
        case "acc": acc += parseInt(value); rip++; break;
        case "jmp": rip += parseInt(value); break;
    }
}
