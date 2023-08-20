const fs = require('fs');
const path = require("path")
const bytes = fs.readFileSync(path.join(__dirname, 'is_prime.wasm'));
const value = parseInt(process.argv[2]);
(async () => {
    const start = process.hrtime();

    const obj =
        await WebAssembly.instantiate(new Uint8Array(bytes));
    if (!!obj.instance.exports.is_prime(value)) {
        console.log(`
			${value} is prime!
		`);
    }
    else {
        console.log(`
			${value} is NOT prime
		`);
    }

    const end = process.hrtime(start);
    console.log(end)
})();