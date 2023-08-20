(module
    (import "js" "external_call" (func $external_call (result i32)))
    (global $i (mut i32) (i32.const 0))

    (func $internal_call (result i32)
        global.get $i
        i32.const 1
        i32.add
        global.set $i

        global.get $i
        ;; global.tee はないらしい
    )

    (func (export "wasm_call")
        (
            loop $again
                call $internal_call
                i32.const 4_000_000
                i32.le_u
                br_if $again
        )
    )
    (func (export "js_call")
        (
            loop $again
                ;; import した関数でも、return された値はスタックにプッシュされる
                call $external_call
                i32.const 4_000_000
                i32.le_u
                br_if $again
        )
    )
)