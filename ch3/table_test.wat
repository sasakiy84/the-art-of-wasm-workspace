(module
    (import "js" "tbl" (table $tbl 4 anyfunc))
    (import "js" "increment" (func $increment (result i32)))
    (import "js" "decrement" (func $decrement (result i32)))
    ;; 直接importした関数と、table経由で呼び出した関数のパフォーマンスを比べるため
    (import "js" "wasm_increment" (func $wasm_increment (result i32)))
    (import "js" "wasm_decrement" (func $wasm_decrement (result i32)))

    ;; テーブル内の関数のシグネチャを定義する
    (type $returns_i32 (func (result i32)))

    (global $inc_ptr i32 (i32.const 0))
    (global $dec_ptr i32 (i32.const 1))
    (global $wasm_inc_ptr i32 (i32.const 2))
    (global $wasm_dec_ptr i32 (i32.const 3))

    ;; js の間接呼び出し
    (func (export "js_table_test")
        (loop $inc_cycle
            (call_indirect (type $returns_i32) (global.get $inc_ptr))
            i32.const 4_000_000
            i32.le_u
            br_if $inc_cycle
        )
        (loop $dec_cycle
            (call_indirect (type $returns_i32) (global.get $dec_ptr))
            i32.const 4_000_000
            i32.le_u
            br_if $dec_cycle
        )
    )
    ;; js の直接呼び出し
    (func (export "js_import_test")
        (loop $inc_cycle
            call $increment
            i32.const 4_000_000
            i32.le_u
            br_if $inc_cycle
        )
        (loop $dec_cycle
            call $decrement
            i32.const 4_000_000
            i32.le_u
            br_if $dec_cycle
        )
    )
    ;; wasm の間接呼び出し
    (func (export "wasm_table_test")
        (loop $inc_cycle
            (call_indirect (type $returns_i32) (global.get $wasm_inc_ptr))
            i32.const 4_000_000
            i32.le_u
            br_if $inc_cycle
        )
        (loop $dec_cycle
            (call_indirect (type $returns_i32) (global.get $wasm_dec_ptr))
            i32.const 4_000_000
            i32.le_u
            br_if $dec_cycle
        )
    )
    ;; wasm の直接呼び出し
    (func (export "wasm_import_test")
        (loop $inc_cycle
            call $wasm_increment
            i32.const 4_000_000
            i32.le_u
            br_if $inc_cycle
        )
        (loop $dec_cycle
            call $wasm_decrement
            i32.const 4_000_000
            i32.le_u
            br_if $dec_cycle
        )
    )

    (func (export "decrement_test") (result i32)
        i32.const 0
        i32.const 1
        i32.sub
        i32.const 0
        i32.le_u
    )
)