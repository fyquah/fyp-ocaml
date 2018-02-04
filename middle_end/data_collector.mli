(*
 * [Data_collector] is a terrible name as this module doesn't actually
 * perform any data collection.
 *
 * It provides a type to denote every inlining decision, that is it
 *   - allows the compiler to store all the decisions it had made
 *   - allows the user to specify a list of inlining decisions override that
 *     the user wants to make
 *
 * V0 - Started 16 October 2017, records by Closure_id and a custom offset
 * V1 - Started 2 February 2018, records by [Closure_origin] and [Apply_id]
 *)

[@@@ocaml.warning "+a-4-9-30-40-41-42"]

module V0 : sig

  module Query : sig
    type t =
      { call_stack : Call_site.t list;
        applied: Closure_id.t;
      }
  end

  type t =
    { call_stack : Call_site.t list;
      applied : Closure_id.t;
      decision : bool;
    }
  
  val sexp_of_t : t -> Sexp.t
  val t_of_sexp : Sexp.t -> t
  
  val inlining_decisions : t list ref
  
  val inlining_overrides : t list ref
  
  val save : output_prefix: string -> unit
  
  val load_from_channel : in_channel -> t list
  
  val pprint_list : Format.formatter -> t list -> unit
  
  val equal : t -> t -> bool
  
  val find_decision
     : t list
    -> call_stack: Call_site.t list
    -> applied: Closure_id.t
    -> bool option
end

module V1 : sig
  (* TODO(fyq14): Surely [source] in [enter_decl] and [at_call_site] below
   *              are really just redundancy? These shouldn't be included
   *              in files to reduce their size!!
   *)

  module Function_metadata : sig
    type t =
      { closure_id: Closure_id.t option;
        set_of_closures_id: Set_of_closures_id.t option;
        closure_origin: Closure_origin.t;
      }

    val sexp_of_t : t -> Sexp.t
    val t_of_sexp : Sexp.t -> t
  end

  module Trace_item : sig
    type enter_decl =
      { source: Function_metadata.t option;  (* None for top level *)
        declared: Function_metadata.t;
      }

    val sexp_of_enter_decl : enter_decl -> Sexp.t
    val enter_decl_of_sexp : Sexp.t -> enter_decl

    type at_call_site =
      { source: Function_metadata.t option;
        apply_id: Apply_id.t;
        applied: Function_metadata.t;
      }

    val sexp_of_at_call_site : at_call_site -> Sexp.t
    val at_call_site_of_sexp : Sexp.t -> at_call_site

    type t =
      | Enter_decl of enter_decl
      | At_call_site of at_call_site

    val sexp_of_t : t -> Sexp.t
    val t_of_sexp : Sexp.t -> t
  end

  (* What we decided to do at the call site, using this rather than a
   * boolean to reflect:
   *   - the "MDP"-like behaviour (argued in the interim report)
   *   - it is possible that we want to support more than Inline and Apply,
   *     of which we won't need to make a new version just for that (as
   *     sexp decoding will be similar)
   *)
  module Action : sig
    type t =
      | Inline
      | Apply  (* Aka do nothing *)

    val sexp_of_t : t -> Sexp.t
    val t_of_sexp : Sexp.t -> t
  end

  (* Can refer to either:
    *   (0) A decision made by the compiler
    *   (1) A decision made by the optimiser
    *)
  module Decision : sig
    type t =
      { round:    int;
        trace:    Trace_item.t list;
        apply_id: Apply_id.t;
        action:   Action.t;
        metadata: Function_metadata.t;
      }

    val recorded_from_flambda : t list ref

    val sexp_of_t : t -> Sexp.t
    val t_of_sexp : Sexp.t -> t
  end

  module Overrides : sig
    type t

    type query = {
      trace: Trace_item.t list;
      apply_id: Apply_id.t;
    }

    val sexp_of_t : t -> Sexp.t

    val t_of_sexp : Sexp.t -> t

    val find_decision : t -> query -> Action.t option
  end
end

include module type of V1

(* Strictly used only by the compiler to make overrides, so no need sexp
 * functions here.
 *)
module Multiversion_overrides : sig
  type t =
    | V0 of V0.t list
    | V1 of V1.Overrides.t
    | Don't

  type query = V0.Query.t * V1.Overrides.query

  val find_decision : t -> query -> Action.t option
end
