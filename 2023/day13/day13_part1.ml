open Printf

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
  let new_map = Array.of_list (map |> String.split_on_char '\n' |> List.map (Bytes.of_string)) in new_map

let transpose (matrix: bytes array) : bytes array =
  let rows = Array.length matrix in
  if rows = 0 then [||]
  else
    let cols = Bytes.length matrix.(0) in
    Array.init cols (fun i ->
      let new_row = Bytes.create rows in
      Array.iteri (fun j row -> Bytes.set new_row j (Bytes.get row i)) matrix;
      new_row
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

(*main part of the program*)
let () =
  let str = read_whole_file "day13.txt" in 
  let l = str |> String.split_on_char '\n' |> Array.of_list in
  let final_maps = List.map (fun x -> String.sub x 0 ((String.length x) - 1)) (maps l 0) in
  List.iter (fun x -> Array.iter (fun y -> printf "%s\n" (Bytes.to_string y)) (transpose (convert_map x)); print_endline "\n") final_maps
