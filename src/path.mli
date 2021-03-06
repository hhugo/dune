open Import

(** In the current worksapce (anything under the current project root) *)
module Local : sig
  type t

  val root : t
  val to_string : t -> string
  val ensure_parent_directory_exists : t -> unit
  val append : t -> t -> t
  val descendant : t -> of_:t -> t option
end

(** In the outside world *)
module External : sig
  type t

  val to_string : t -> string
end

module Kind : sig
  type t =
    | External of External.t
    | Local    of Local.t
end

type t

val compare : t -> t -> int

module Set : Set.S with type elt = t
module Map : Map.S with type key = t

val kind : t -> Kind.t

val of_string : string -> t
val to_string : t -> string

val root : t

val is_local : t -> bool

val relative : t -> string -> t

val absolute : string -> t

val reach : t -> from:t -> string

val descendant : t -> of_:t -> t option

val append : t -> t -> t

val basename : t -> string
val parent : t -> t

val extract_build_context : t -> (string * t) option
val is_in_build_dir : t -> bool

val exists : t -> bool
val readdir : t -> string array
val is_directory : t -> bool
val rmdir : t -> unit
val unlink : t -> unit
