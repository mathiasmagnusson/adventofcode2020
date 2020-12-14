const lines = new TextDecoder("utf8")
    .decode(await Deno.readFile("in"))
    .split("\n")
    .map(line => {
        const [instruction, value] = line.split(" ")
        return { instruction, value: parseInt(value) }
    })
    .filter(line => line.instruction != "")

function run(lines: { instruction: string, value: number }[]) {
    const seenLines = new Set<number>()
    let acc = 0, rip = 0
    while (true) {
        if (seenLines.has(rip)) {
            return { seenLines, acc, rip, terminates: false }
        } else if (rip === lines.length) {
            return { seenLines, acc, rip, terminates: true }
        }
        seenLines.add(rip)

        let { instruction, value } = lines[rip]
        switch (instruction) {
            case "nop": rip++; break
            case "acc": acc += value; rip++; break
            case "jmp": rip += value; break
        }
    }
}

for (let i = 0; i < lines.length; i++) {
    if (lines[i].instruction === "nop") {
        lines[i].instruction = "jmp"

        if (run(lines).terminates) {
            break
        }

        lines[i].instruction = "nop"
    } else if (lines[i].instruction === "jmp") {
        lines[i].instruction = "nop"

        if (run(lines).terminates) {
            break
        }

        lines[i].instruction = "jmp"
    }
}

const { terminates, acc } = run(lines)
console.log(terminates, acc)
