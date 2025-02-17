open Printf
exception Break;;

let read_whole_file filename =
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
  in
  let chan = open_in filename in
    read_whole_chan chan

let rec maps map_sep index =
  let rec group_one_map map_sep index =
    match String.length map_sep.(index) with
     | 0 -> ("", index)
     | _ -> let (s, i) = group_one_map map_sep (index + 1) in (map_sep.(index) ^ "\n" ^ s, i)
  in
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

let symmetry (arr : string array) ignore =
  let rec chop_last = function
    | [] ->
        [] (* Empty list: return empty list *)
    | [_] ->
        [] (* Single-element list: return empty list *)
    | x :: xs ->
        x :: chop_last xs
  in
  let rec check_head (arr : string array) index pass_it : int list =
    if index = 0 && pass_it = true then [-1]
    else if arr.(index) = arr.(0) then index :: check_head arr (index - 1) true
    else check_head arr (index - 1) true
  in
  let rec check_tail (arr : string array) index pass_it : int list =
    if index = Array.length arr - 1 && pass_it = true then [-1]
    else if arr.(index) = arr.(Array.length arr - 1) then
      index :: check_tail arr (index + 1) true
    else check_tail arr (index + 1) true
  in
  let perfect_symmetry (arr : string array) list_holding const_index: int * int =
  let rec check pre_change const_index pass_it =
    let i = if pass_it = false then if const_index = 0 then const_index + 1 else pre_change + 1 else pre_change in
    let j = if pass_it = false then if const_index <> 0 then const_index - 1 else pre_change - 1 else const_index in
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
  in
  let trans_arr = transpose arr in
  let res_head = check_head arr (Array.length arr - 1) false in
  let res_tail = check_tail arr 0 false in
  let res_trans_head = check_head trans_arr (Array.length trans_arr - 1) false in
  let res_trans_tail = check_tail trans_arr 0 false in
  let head_result = perfect_symmetry arr (chop_last res_head) 0 in
  let tail_result =
    perfect_symmetry arr (chop_last res_tail) (Array.length arr - 1)
  in
  let head_trans_result = perfect_symmetry trans_arr (chop_last res_trans_head) 0 in
  let tail_trans_result =
    perfect_symmetry trans_arr (chop_last res_trans_tail) (Array.length trans_arr - 1)
  in
  let h_org = List.filter (fun x -> x <> (fst ignore) && x <> -1) [snd head_result; snd tail_result] in
  let v_org = List.filter (fun x -> x <> (snd ignore) && x <> -1) [snd head_trans_result; snd tail_trans_result] in
  let h = if List.length h_org = 0 then -1 else List.hd h_org in
  let v = if List.length v_org = 0 then -1 else List.hd v_org in
  (* printf "pre: %d %d, exe: %d %d %d %d => %d %d\n" (fst ignore) (snd ignore) (snd head_result) (snd tail_result) (snd head_trans_result) (snd head_trans_result) h v; *)
  (h, v)

let symmetry_2 (arr: string array) = 
  let rows = Array.length arr in
  let cols = String.length arr.(0) in
  let org_symmetry = symmetry arr (-1, -1) in
  let res = ref (0, 0) in 
  try 
    for i = 0 to rows - 1 do
      for j = 0 to cols - 1 do
        let copied_arr = Array.copy arr in 
        let arr_final = Array.map Bytes.of_string copied_arr in 

        (* Modify the character in arr_final *)
        let current_char = Bytes.get arr_final.(i) j in
        Bytes.set arr_final.(i) j (if current_char = '.' then '#' else '.');

        let res_tmp = symmetry (Array.map Bytes.to_string arr_final) org_symmetry in 
        if res_tmp <> org_symmetry && res_tmp <> (-1, -1) then begin
          res := res_tmp;
          raise Break;
        end;
      done
    done;
    !res  (* Return the final result if no break occurs *)
  with Break -> !res

let analyze (map : string) =
  let (h, v) = symmetry_2 (convert_map map) in
  if h <> -1 then 100 * (h + 1) else v + 1
  

(*main part of the program*)
let () =
  let str = read_whole_file "day13.txt" in 
  let l = str |> String.split_on_char '\n' |> Array.of_list in
  let final_maps = List.map (fun x -> String.sub x 0 ((String.length x) - 1)) (maps l 0) in
  let res = List.fold_left (fun acc x -> acc + (analyze x)) 0 final_maps in
  printf "%d\n" res;
