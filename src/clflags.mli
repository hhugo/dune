(** Command line flags *)

(** Concurrency *)
val concurrency : int ref

(** Compilation flags for OCaml files *)
(*val ocaml_comp_flags : string list ref*)

(** [-g] *)
val g : bool ref

(** Print rules *)
val debug_rules : bool ref

(** Print executed commands *)
val debug_run : bool ref

(** Print dependency path in case of error *)
val debug_dep_path : bool ref

(** Compiler warnings *)
val warnings : string ref
