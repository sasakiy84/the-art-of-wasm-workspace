const value = parseInt(process.argv[2]);

const is_prime = (n) => {
    if (n === 1) {
        return 0
    }

    if (n === 2) {
        return 1
    }

    if ((n % 2) === 0) {
        return 0
    }

    for (let i = 3; n > i; i += 2) {
        if ((n % i) === 0) {
            return 0
        }
    }

    return 1
}

const start = process.hrtime();

if (!!is_prime(value)) {
    console.log(`${value} is prime`)
} else {
    console.log(`${value} is NOT prime`)
}

const end = process.hrtime(start);
console.log(end)

// 素数
// 10桁: 2147483647	(i32 の最大値)
// wasm で [ 4, 283835900 ]
// js でも [ 4, 178802500 ]