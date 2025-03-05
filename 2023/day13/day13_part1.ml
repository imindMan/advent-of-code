open Printf

(*this is for reading the file*)
let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  try
    while true do
      let line = input_line chan in
      Buffer.add_string buf line ; Buffer.add_char buf '\n'
    done ;
    assert false
  with End_of_file -> Buffer.contents buf

let read_whole_file filename =
  let chan = open_in filename in
  read_whole_chan chan

(*this is for parsing the maps*)
let rec group_one_map map_sep index =
  match String.length map_sep.(index) with
  | 0 ->
      ("", index)
  | _ ->
      let s, i = group_one_map map_sep (index + 1) in
      (map_sep.(index) ^ "\n" ^ s, i)

let rec maps map_sep index =
  if index >= Array.length map_sep then []
  else
    let s, i = group_one_map map_sep index in
    s :: maps map_sep (i + 1)

let convert_map map =
  let new_map = Array.of_list (map |> String.split_on_char '\n') in
  new_map

let transpose (matrix : string array) : string array =
  let rows = Array.length matrix in
  if rows = 0 then [||]
  else
    let cols = String.length matrix.(0) in
    Array.init cols (fun i ->
        let new_row = Bytes.create rows in
        Array.iteri (fun j row -> Bytes.set new_row j (String.get row i)) matrix ;
        Bytes.to_string new_row )

(*logic may be here*)
let rec chop_last = function
  | [] ->
      [] (* Empty list: return empty list *)
  | [_] ->
      [] (* Single-element list: return empty list *)
  | x :: xs ->
      x :: chop_last xs

let perfect_symmetry (arr : string array) list_holding const_index : int * int =
  let rec check pre_change const_index pass_it =
    let i =
      if pass_it = false then
        if const_index = 0 then const_index else pre_change
      else pre_change
    in
    let j =
      if pass_it = false then
        if const_index <> 0 then const_index else pre_change
      else const_index
    in
    if i > j then (i, j) (* Base case: the entire array has been checked *)
    else if arr.(i) = arr.(j) && i <> j then check (i + 1) (j - 1) true
      (* Move towards the center *)
    else (-1, -1)
    (* If elements don't match, return the current indices *)
  in
  let final_list =
    List.filter (fun x -> x <> (-1, -1))
    @@ List.map (fun x -> check x const_index false) list_holding
  in
  if List.length final_list = 0 then (-1, -1) else List.hd final_list

let rec check_head (arr : string array) index pass_it : int list =
  if index = 0 && pass_it = true then [-1]
  else if arr.(index) = arr.(0) then index :: check_head arr (index - 1) true
  else check_head arr (index - 1) true

let rec check_tail (arr : string array) index pass_it : int list =
  if index = Array.length arr - 1 && pass_it = true then [-1]
  else if arr.(index) = arr.(Array.length arr - 1) then
    index :: check_tail arr (index + 1) true
  else check_tail arr (index + 1) true

let symmetry (arr : string array) =
  let res_head = check_head arr (Array.length arr - 1) false in
  let res_tail = check_tail arr 0 false in
  let head_result = perfect_symmetry arr (chop_last res_head) 0 in
  let tail_result =
    perfect_symmetry arr (chop_last res_tail) (Array.length arr - 1)
  in
  if head_result <> (-1, -1) then head_result else tail_result

let analyze (map : string) =
  let rows = symmetry (convert_map map) in
  let cols = symmetry (transpose (convert_map map)) in
  if rows <> (-1, -1) && cols <> (-1, -1) then
    (100 * (snd rows + 1)) + (snd cols + 1)
  else if rows <> (-1, -1) then 100 * (snd rows + 1)
  else snd cols + 1

(*main part of the program*)
let () =
  let str = read_whole_file "day13.txt" in
  let l = str |> String.split_on_char '\n' |> Array.of_list in
  let final_maps =
    List.map (fun x -> String.sub x 0 (String.length x - 1)) (maps l 0)
  in
  let res = List.fold_left (fun acc x -> acc + analyze x) 0 final_maps in
  printf "%d\n" res
