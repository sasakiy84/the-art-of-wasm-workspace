const fs = require('fs');
const path = require("path")
const bytes = fs.readFileSync(path.join(__dirname, 'bigint.wasm'));
(async () => {

    const obj =
        await WebAssembly.instantiate(new Uint8Array(bytes));
    let bigint = BigInt(30)
    bigint = obj.instance.exports.return_bigint()

    const not_bigint = obj.instance.exports.return_bigint()

    console.log({ bigint, not_bigint })
})();