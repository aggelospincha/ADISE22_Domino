var me={token:null,piece_color:null};
var game_status={};
var board={};
var last_update=new Date().getTime();
var timer=null;
$(function () {
	$('#chess_login').click( login_to_game);
	});


function login_to_game() {
	if($('#username').val()=='') {
		alert('You have to set a username');
		return;
	}
//	var p_color = $('#pcolor').val();
//	draw_empty_board(p_color);
//	sharetiles();
	
	$.ajax({url: "domino.php/players/", 
			method: 'PUT',
			dataType: "json",
			headers: {"X-Token": me.token},
			contentType: 'application/json',
			data: JSON.stringify( {username: $('#username').val()}),
			success: login_result,
			error: login_error});
}

function login_result(data) {
	me = data[0];
	$('#game_initializer').hide();
	update_info();
	game_status_update();
}

function login_error(data,y,z,c) {
	var x = data.responseJSON;
	alert(x.errormesg);
}


function game_status_update() {
	
	clearTimeout(timer);
	$.ajax({url: "domino.php/status/", success: update_status,headers: {"X-Token": me.token} });
}






