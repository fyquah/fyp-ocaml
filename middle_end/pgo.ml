type overhead = string

type symbol = string

type loc = (string * int)

type t =
  { overhead: overhead;
    call_stack: (symbol * loc) list;
    children: t list;
  }

type top_level = t list
