<?php


/*its not completed for sure*/

function read_status()
{
	global $mysqli;
	$sql = 'select * from gameStatus';
	$st = $mysqli->prepare($sql);
	$st->execute();
	$res = $st->get_result();
	$status = $res->fetch_assoc();
	return ($status);
}

function reset_board(){
	global $mysqli;

	$sql = 'call clean_board()';
	$mysqli->query($sql);
	show_board();
}

function show_board(){
	$res = read_board();
	print json_encode($res, JSON_PRETTY_PRINT);
}

function show_tiles($x,$y) {
	global $mysqli;
	
	$sql = 'select * from tile where firstvalue=? and secondvalue=?';
	$st = $mysqli->prepare($sql);
	$st->bind_param('tile',$x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);
}


function fill_board($x,$y){
	global $mysqli;

	$sql='call play_tile('?','?')';
	$st= $mysqli->prepare($sq1);
	$st->bind_paradam($x,$y);
	$st->execute();
	$res = $st->get_result();
	header('Content-type: application/json');
	print json_encode($res->fetch_all(MYSQLI_ASSOC), JSON_PRETTY_PRINT);


}




?>