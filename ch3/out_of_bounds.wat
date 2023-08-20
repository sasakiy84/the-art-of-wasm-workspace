(
    module
        (func $inner (result i32)
            (local $l i32)
            local.set $l
            ;; 5:13: error: type mismatch in local.set, expected [i32] but got []        
            ;; set_local $l
            ;; ちなみに 5 行目を消しても、余計なもの（99）がスタックにあるというエラーで、コンパイルが失敗する
            i32.const 2
        )
        (func (export "main") (result i32)
            i32.const 99
            call $inner
            ;; 10:13: error: type mismatch in function, expected [] but got [i32]        
            ;; call $inner
        )
)