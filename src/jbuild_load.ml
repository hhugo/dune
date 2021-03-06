open Import
open Jbuild_types

let load fn ~dir = (dir, Sexp_load.many fn Stanza.t)

let always_ignore =
  String_set.of_list
    [ ""
    ; "_build"
    ; ".git"
    ; ".hg"
    ]

let load () =
  let rec walk dir stanzas =
    let files = Path.readdir dir |> Array.to_list |> String_set.of_list in
    let ignore_set =
      if String_set.mem "jbuild-ignore" files then
        String_set.union
          (lines_of_file (Path.to_string (Path.relative dir "jbuild-ignore"))
           |> String_set.of_list)
          always_ignore
      else
        always_ignore
    in
    let children, stanzas =
      String_set.fold files ~init:([], stanzas) ~f:(fun fn ((children, stanzas) as acc) ->
        if String_set.mem fn ignore_set || fn.[0] = '.' then
          acc
        else
          let fn = Path.relative dir fn in
          if Path.exists fn && Path.is_directory fn then
            let child, stanzas = walk fn stanzas in
            (child :: children, stanzas)
          else
            acc)
    in
    let stanzas =
      if String_set.mem "jbuild" files then
        load (Path.to_string (Path.relative dir "jbuild")) ~dir :: stanzas
      else
        stanzas
    in
    (Alias.Node (dir, children), stanzas)
  in
  walk Path.root []
