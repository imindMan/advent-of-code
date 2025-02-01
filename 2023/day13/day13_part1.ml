open Printf
(*logic may be here*)
let perfect_symmetry (arr: string array) prefix : int * int = 
  let n = Array.length arr in
  let rec check i j prefix =
    if i >= j then (i + prefix, j + prefix)  (* Base case: the entire array has been checked *)
    else if arr.(i) = arr.(j) then check (i + 1) (j - 1) prefix  (* Move towards the center *)
    else (-1, -1) (* If elements don't match, return the current indices *)
  in
  check 0 (n - 1) prefix (* Start checking from the first and last elements *)

let rec check_head (arr : string array) index pass_it: int = 
  if index = 0 && pass_it = true then -1 
  else if arr.(index) = arr.(0) then index
  else check_head arr (index - 1) true

let rec check_tail (arr : string array) index pass_it: int = 
  if index = Array.length arr - 1 && pass_it = true then -1
  else if arr.(index) = arr.(Array.length arr - 1) then index
  else check_tail arr (index + 1) true

let symmetry (arr : string array) = 
  let res_head = check_head arr (Array.length arr - 1) false in
  let res_tail = check_tail arr 0 false in
  if res_head = -1 && res_tail = -1 then (-1, -1)
  else if res_head <> -1 && res_tail <> -1 then
    let head = perfect_symmetry (Array.sub arr 0 (res_head + 1)) 0 in
    let tail = perfect_symmetry (Array.sub arr res_tail (Array.length arr - res_tail)) res_tail in 
    if head <> (-1, -1) then tail
    else head
  else if res_tail <> -1 then perfect_symmetry (Array.sub arr res_tail (Array.length arr - res_tail)) res_tail
  else perfect_symmetry (Array.sub arr 0 (res_head + 1)) 0
(*this is for parsing the maps*)
let rec group_one_map map_sep index =
  match String.length map_sep.(index) with
   | 0 -> ("", index)
   | _ -> let (s, i) = group_one_map map_sep (index + 1) in (map_sep.(index) ^ "\n" ^ s, i)

let rec maps map_sep index =
  if index >= (Array.length map_sep) then []
  else 
    let (s, i) = group_one_map map_sep index in
    s :: (maps map_sep (i + 1))

let convert_map map = 
  let new_map = Array.of_list (map |> String.split_on_char '\n') in new_map

let transpose (matrix: string array) : string array =
  let rows = Array.length matrix in
  if rows = 0 then [||]
  else
    let cols = String.length matrix.(0) in
    Array.init cols (fun i ->
      let new_row = Bytes.create rows in
      Array.iteri (fun j row -> Bytes.set new_row j (String.get row i)) matrix;
      Bytes.to_string new_row
    )

(*this is for reading the file*)
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  try
    while true do
     let line = input_line chan in
        Buffer.add_string buf line;
        Buffer.add_char buf '\n'
    done;
    assert false 
  with
    End_of_file -> Buffer.contents buf

let read_whole_file filename =
  let chan = open_in filename in
    read_whole_chan chan

let analyze (map : string) =
  printf "%s\n\n" map;
  let rows = symmetry (convert_map map) in
  let cols = symmetry (transpose (convert_map map)) in
  if rows <> (-1, -1) && cols <> (-1, -1) then 100 * (snd rows + 1) + (snd cols + 1)
  else if rows <> (-1, -1) then 100*(snd rows + 1)
  else snd cols + 1

(*main part of the program*)
let () =
  let str = read_whole_file "day13.txt" in 
  let l = str |> String.split_on_char '\n' |> Array.of_list in
  let final_maps = List.map (fun x -> String.sub x 0 ((String.length x) - 1)) (maps l 0) in
  let res = List.fold_left (fun acc x -> acc + (analyze x)) 0 final_maps in
  print_int res
  
