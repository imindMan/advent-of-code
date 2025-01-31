open Printf

(*this is for parsing the maps*)
let rec group_one_map map_sep index =
  match String.length map_sep.(index) with
   | 0 -> ("", index)
   | _ -> let (s, i) = group_one_map map_sep (index + 1) in (map_sep.(index) ^ "\n" ^ s, i)

let rec maps map_sep =
   
  
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
      Array.iter (printf "%s\n") l;
      printf "'%s' %d" (fst (group_one_map l 8)) (snd (group_one_map l 8))
