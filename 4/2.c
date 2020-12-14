#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>

bool valid_byr(char* value) {
    return strcmp(value, "1920") >= 0 && strcmp(value, "2002") <= 0;
}

bool valid_iyr(char* value) {
    return strcmp(value, "2010") >= 0 && strcmp(value, "2020") <= 0;
}

bool valid_eyr(char* value) {
    return strcmp(value, "2020") >= 0 && strcmp(value, "2030") <= 0;
}

bool valid_hgt(char* value) {
    int height;
    char unit;
    int found = sscanf(value, "%d%c", &height, &unit);

    if (found != 2) return false;

    if (unit == 'c') {
        return 150 <= height && height <= 193;
    } else {
        return 59 <= height && height <= 76;
    }
}

bool valid_hcl(char* value) {
    if (strlen(value) != 7) return false;
    if (value[0] != '#') return false;
    for (int i = 1; i < 7; i++) {
        char c = value[i];
        if (!('0' <= c && c <= '9') &&
            !('a' <= c && c <= 'f'))
            return false;
    }
    return true;
}

bool valid_ecl(char* value) {
    if (strlen(value) != 3) return false;
    return strcmp(value, "amb") == 0 ||
           strcmp(value, "blu") == 0 ||
           strcmp(value, "brn") == 0 ||
           strcmp(value, "gry") == 0 ||
           strcmp(value, "grn") == 0 ||
           strcmp(value, "hzl") == 0 ||
           strcmp(value, "oth") == 0;
}

bool valid_pid(char* value) {
    if (strlen(value) != 9) return false;
    for (int i = 0; i < 9; i++) {
        char c = value[i];
        if (!('0' <= c && c <= '9'))
            return false;
    }
    return true;
}

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
    if (strncmp(field, "byr", 3) == 0 && valid_byr(&field[4])) passport |= byr;
    if (strncmp(field, "iyr", 3) == 0 && valid_iyr(&field[4])) passport |= iyr;
    if (strncmp(field, "eyr", 3) == 0 && valid_eyr(&field[4])) passport |= eyr;
    if (strncmp(field, "hgt", 3) == 0 && valid_hgt(&field[4])) passport |= hgt;
    if (strncmp(field, "hcl", 3) == 0 && valid_hcl(&field[4])) passport |= hcl;
    if (strncmp(field, "ecl", 3) == 0 && valid_ecl(&field[4])) passport |= ecl;
    if (strncmp(field, "pid", 3) == 0 && valid_pid(&field[4])) passport |= pid;
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
