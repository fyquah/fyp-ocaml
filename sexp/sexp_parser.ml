
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | STRING of (
# 1 "sexp/sexp_parser.mly"
       (string)
# 11 "sexp/sexp_parser.ml"
  )
    | RIGHT_BRACE
    | LEFT_BRACE
    | EOF
  
end

include MenhirBasics

let _eRR =
  MenhirBasics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState7
  | MenhirState5
  | MenhirState2
  | MenhirState0

let rec _menhir_fail : unit -> 'a =
  fun () ->
    Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

and _menhir_reduce6 : _menhir_env -> ('ttv_tail * _menhir_state) * _menhir_state * 'tv_sexp_list -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let ((_menhir_stack, _menhir_s), _, (obj : 'tv_sexp_list)) = _menhir_stack in
    let _3 = () in
    let _1 = () in
    let _v : 'tv_value = 
# 15 "sexp/sexp_parser.mly"
                                             ( Sexp.List obj )
# 50 "sexp/sexp_parser.ml"
     in
    _menhir_goto_value _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_value : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_value -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv47 * _menhir_state * 'tv_rev_sexp_list) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_value) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv45 * _menhir_state * 'tv_rev_sexp_list) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((hd : 'tv_value) : 'tv_value) = _v in
        ((let (_menhir_stack, _menhir_s, (tl : 'tv_rev_sexp_list)) = _menhir_stack in
        let _v : 'tv_rev_sexp_list = 
# 23 "sexp/sexp_parser.mly"
                                   ( hd :: tl )
# 70 "sexp/sexp_parser.ml"
         in
        _menhir_goto_rev_sexp_list _menhir_env _menhir_stack _menhir_s _v) : 'freshtv46)) : 'freshtv48)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv51) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_value) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv49) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((v : 'tv_value) : 'tv_value) = _v in
        ((let _v : (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 85 "sexp/sexp_parser.ml"
        ) = 
# 11 "sexp/sexp_parser.mly"
              ( Some v )
# 89 "sexp/sexp_parser.ml"
         in
        _menhir_goto_prog _menhir_env _menhir_stack _menhir_s _v) : 'freshtv50)) : 'freshtv52)
    | _ ->
        _menhir_fail ()

and _menhir_goto_rev_sexp_list : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_rev_sexp_list -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv43 * _menhir_state * 'tv_rev_sexp_list) = Obj.magic _menhir_stack in
    ((assert (not _menhir_env._menhir_error);
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | LEFT_BRACE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv23) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState5 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        _menhir_reduce3 _menhir_env (Obj.magic _menhir_stack) MenhirState7) : 'freshtv24)
    | STRING _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv25) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState5 in
        let (_v : (
# 1 "sexp/sexp_parser.mly"
       (string)
# 117 "sexp/sexp_parser.ml"
        )) = _v in
        ((let _menhir_env = _menhir_discard _menhir_env in
        _menhir_reduce7 _menhir_env (Obj.magic _menhir_stack) _menhir_s _v) : 'freshtv26)
    | RIGHT_BRACE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv41 * _menhir_state * 'tv_rev_sexp_list) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, (obj : 'tv_rev_sexp_list)) = _menhir_stack in
        let _v : 'tv_sexp_list = 
# 19 "sexp/sexp_parser.mly"
                               ( List.rev obj )
# 128 "sexp/sexp_parser.ml"
         in
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv39) = _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_sexp_list) = _v in
        ((let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
        match _menhir_s with
        | MenhirState2 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv31 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | RIGHT_BRACE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv27 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
                (_menhir_reduce6 _menhir_env (Obj.magic _menhir_stack) : 'freshtv28)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv29 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)) : 'freshtv32)
        | MenhirState7 ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv37 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
            ((assert (not _menhir_env._menhir_error);
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | RIGHT_BRACE ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv33 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                _menhir_reduce6 _menhir_env (Obj.magic _menhir_stack)) : 'freshtv34)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv35 * _menhir_state) * _menhir_state * 'tv_sexp_list) = Obj.magic _menhir_stack in
                ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv36)) : 'freshtv38)
        | _ ->
            _menhir_fail ()) : 'freshtv40)) : 'freshtv42)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState5) : 'freshtv44)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState5 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17 * _menhir_state * 'tv_rev_sexp_list) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv18)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv19 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv20)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv21) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv22)

and _menhir_reduce7 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 1 "sexp/sexp_parser.mly"
       (string)
# 204 "sexp/sexp_parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s (s : (
# 1 "sexp/sexp_parser.mly"
       (string)
# 209 "sexp/sexp_parser.ml"
  )) ->
    let _v : 'tv_value = 
# 16 "sexp/sexp_parser.mly"
               ( Sexp.Atom s )
# 214 "sexp/sexp_parser.ml"
     in
    _menhir_goto_value _menhir_env _menhir_stack _menhir_s _v

and _menhir_reduce3 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _v : 'tv_rev_sexp_list = 
# 22 "sexp/sexp_parser.mly"
                ( [] )
# 223 "sexp/sexp_parser.ml"
     in
    _menhir_goto_rev_sexp_list _menhir_env _menhir_stack _menhir_s _v

and _menhir_goto_prog : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 230 "sexp/sexp_parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv13) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let (_v : (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 239 "sexp/sexp_parser.ml"
    )) = _v in
    ((let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv11) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((_1 : (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 247 "sexp/sexp_parser.ml"
    )) : (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 251 "sexp/sexp_parser.ml"
    )) = _v in
    (Obj.magic _1 : 'freshtv12)) : 'freshtv14)

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 270 "sexp/sexp_parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv9) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | EOF ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState0 in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        ((let _1 = () in
        let _v : (
# 6 "sexp/sexp_parser.mly"
       (Sexp.t option)
# 300 "sexp/sexp_parser.ml"
        ) = 
# 10 "sexp/sexp_parser.mly"
        ( None )
# 304 "sexp/sexp_parser.ml"
         in
        _menhir_goto_prog _menhir_env _menhir_stack _menhir_s _v) : 'freshtv2)) : 'freshtv4)
    | LEFT_BRACE ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState0 in
        ((let _menhir_stack = (_menhir_stack, _menhir_s) in
        let _menhir_env = _menhir_discard _menhir_env in
        _menhir_reduce3 _menhir_env (Obj.magic _menhir_stack) MenhirState2) : 'freshtv6)
    | STRING _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv7) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = MenhirState0 in
        let (_v : (
# 1 "sexp/sexp_parser.mly"
       (string)
# 321 "sexp/sexp_parser.ml"
        )) = _v in
        (_menhir_reduce7 _menhir_env (Obj.magic _menhir_stack) _menhir_s _v : 'freshtv8)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv10))

# 219 "/Users/fyq14/.opam/4.05.0/lib/menhir/standard.mly"
  


# 333 "sexp/sexp_parser.ml"
