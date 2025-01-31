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
 
let transpose map = 
  for i = 0 to (Array.length map) - 1 do
    for j = 0 to (Bytes.length map.(0)) - 1 do
      printf "%d %d\n" i j;
      (*swap things*)
      let k = Bytes.get map.(i) j in
      Bytes.set map.(i) j (Bytes.get map.(j) i);
      Bytes.set map.(j) i k;
    done;
  done;;

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

(*main part of the program. don't know why i cant use main ()*)
let () =
  let str = read_whole_file "day13.txt" in 
  let l = str |> String.split_on_char '\n' |> Array.of_list in
  let final_maps = List.map (fun x -> String.sub x 0 ((String.length x) - 1)) (maps l 0)  in
    List.iter (fun x -> let x_arr = (Array.map (Bytes.of_string) (Array.of_list (x |> String.split_on_char '\n'))) in transpose x_arr; Array.iter (fun y -> printf "'%s',\n" (Bytes.to_string y)) x_arr) final_maps
