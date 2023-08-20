(
    module
        ;; $n が偶数の場合、 1 を返す
        (func $even_check (param $n i32) (result i32)
            local.get $n
            i32.const 2
            ;; スタックから値を2つ取り出し、最後に取り出した値を最初に取り出した値で割り、その余りをスタックにプッシュする
            i32.rem_u ;; remainder = 余り
            i32.const 0
            i32.eq ;; スタックから値を二つ取り出し、等しい場合は1、そうでない場合は0をプッシュする
        )
        ;; $n が 2 の場合 1 を返す
        (func $eq_2 (param $n i32) (result i32)
            local.get $n
            i32.const 2
            i32.eq
        )
        ;; $n が $m の倍数だった場合、1を返す
        (func $multiple_check (param $n i32) (param $m i32) (result i32)
            local.get $n
            local.get $m
            i32.rem_u ;; $n % $m
            i32.const 0
            i32.eq
        )
        ;; $n が素数だった場合は 1 を返す、それ以外は 0 を返す
        (func (export "is_prime") (param $n i32) (result i32)
        ;; 以下のように $is_prime ラベルを付ければ、モジュール内でも使えるようになる
        ;; (func $is_prime (export "is_prime") (param $n i32) (result i32)
            (local $i i32)

            ;; $n が 1 だった場合の処理
            (if (i32.eq (local.get $n) (i32.const 1))
                (then
                    i32.const 0 ;; 1 は素数ではない
                    return
                )
            )
            ;; S式を展開すると以下のようになるはず(cf. p37)
            ;; local.get $n
            ;; local.get $i32.const 1
            ;; i32.eq
            ;; if
            ;; i32.const 0
            ;; return
            ;; end

            ;; $n が 2 だった場合の処理
            (if (call $eq_2 (local.get $n))
                (then
                    i32.const 1 ;; 2 は素数
                    return
                )
            )

            ;; $n が 3 以上だった場合の処理
            (block $not_prime
                (call $even_check (local.get $n))
                ;; $n が偶数だった場合、スタックに 1 が積まれている
                br_if $not_prime ;; 2 以外の偶数は素数ではない

                (local.set $i (i32.const 1))

                (loop $prime_test_loop
                    ;; i += 2 をする
                    (local.tee $i
                        (i32.add (local.get $i) (i32.const 2))
                    )
                    ;; local.get: 変数の値をスタックにプッシュする
                    ;; local.set: スタックの値をポップし、変数に格納する
                    ;; local.tee: スタックの値をポップせずに、変数に格納する
                    ;; tee は正確には、set した後に get してるっぽい？
                    ;; > The local.tee instruction sets the value of a local variable and loads the value onto the stack.
                    ;; https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Variables/Local_tee
                    ;; tee は、配管用語の Tスプリッターから来ている（コマンドと同じ？）
                    ;; 変数にもスタックにも同じ値を流すというイメージ

                    ;; S式を展開すると以下のようになる
                    ;; i32.const 2
                    ;; local.get $i
                    ;; i32.add
                    ;; local.tee $i

                    local.get $n ;; stack = [$n, $i]

                    i32.ge_u ;; $i >= $n だった場合、 1 がスタックにプッシュされ、次の if 文でつかわれる
                    if ;; $i >= $n の場合、$n は素数
                        i32.const 1
                        return
                    end

                    ;; $n が $i の倍数だった場合、 1 がプッシュされる
                    (call $multiple_check (local.get $n) (local.get $i))

                    br_if $not_prime
                    br $prime_test_loop
                )
            )
            ;; ここまで来るということは、素数ではないということ
            i32.const 0
        )
)