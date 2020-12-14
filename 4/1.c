#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>

const uint8_t byr = 1 << 0;
const uint8_t iyr = 1 << 1;
const uint8_t eyr = 1 << 2;
const uint8_t hgt = 1 << 3;
const uint8_t hcl = 1 << 4;
const uint8_t ecl = 1 << 5;
const uint8_t pid = 1 << 6;

int valid = 0;
void process_passport(uint8_t passport) {
    if (passport == (byr | iyr | eyr | hgt | hcl | ecl | pid))
        valid++;
}

bool last_null = false;
void process_field(char* field) {
    printf("%s\n", field);

    static uint8_t passport = 0;
    if (field == NULL) {
        if (last_null) {
            process_passport(passport);
            passport = 0;
        }
        last_null = true;
        return;
    }
    last_null = false;
    if (memcmp(field, "byr", 3) == 0) passport |= byr;
    if (memcmp(field, "iyr", 3) == 0) passport |= iyr;
    if (memcmp(field, "eyr", 3) == 0) passport |= eyr;
    if (memcmp(field, "hgt", 3) == 0) passport |= hgt;
    if (memcmp(field, "hcl", 3) == 0) passport |= hcl;
    if (memcmp(field, "ecl", 3) == 0) passport |= ecl;
    if (memcmp(field, "pid", 3) == 0) passport |= pid;
}

int main() {
    FILE *in = fopen("in", "r");

    char line[1024]; line[(sizeof line) - 1] = '\0';

    while (fgets(line, sizeof line, in) != NULL) {
        char *token, *saveptr = NULL;
        while (true) {
            token = strtok_r(saveptr ? 0 : line, " \n", &saveptr);
            process_field(token);
            if (!token) break;
        }
    }

    process_field(NULL);

    printf("%d\n", valid);

    fclose(in);
}
