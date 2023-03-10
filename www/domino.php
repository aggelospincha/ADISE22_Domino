<?php 
require_once "../lib/dbconnection.php";
require_once "../lib/board.php";
require_once "../lib/game.php";
require_once "../lib/players.php";

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$input = json_decode(file_get_contents('php://input'),true);
if($input==null) {
    $input=[];
}
if(isset($_SERVER['HTTP_X_TOKEN'])) {
    $input['token']=$_SERVER['HTTP_X_TOKEN'];
} else {
    $input['token']='';
}


$input1 = json_decode(file_get_contents('php://input'),true);
if($input1==null) {
    $input1=[];
}
if(isset($_SERVER['HTTP_X_TOKEN'])) {
    $input1['token']=$_SERVER['HTTP_X_TOKEN'];
} else {
    $input1['token']='';
}







switch($r=array_shift($request)){
    case'players': handle_player($method,$request,$input);
        break;
    case'status':handle_status($method,$request,$input);
        break;
    case'board':handle_board($method,$request,$input);
        break;
    case'tiles':handle_tiles($method,$request,$input);
        break;
    case'play':handle_game($method,$request,$input,$input1);
        break;
    case'abort':handle_abort($method,$request,$input);
        break;
    case 'draw':handle_draw($method,$request,$input);
        break;
    default :header("HTTP/1.1 404 NOT Found");
        exit;
     

}


function handle_draw($method,$p,$input){
    $b=array_shift($p);
    if($b=='' or null){
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Method $method not allowed here."]);
      } 
      if ($method=='PUT'){
        drawtile($b);
        }

}

function handle_game($method,$input,$input1){
    //$b=array_shift($p);
    //$tilename=$_GET['tile']
    if($method=='GET') {
        show_board();
    }elseif($method=='PUT'){
    play_tile($input,$input1);/*,$input['token']*/
    }else{
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Method $method not allowed here."]);
}
}


function handle_tiles($method,$p){
    $b=array_shift($p);
    if($b=='' or null){
    if($method=='GET'){
        show_sharedtiles();
    }
    elseif($method=='PUT'){
        sharetiles();
    }
}else{
    if($method=='GET'){
        show_players_sharedtiles($b);
        }else{header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"Method $method not allowed here."]);}
    }
    


}



function handle_player($method, $p,$input) {
    $b=array_shift($p);
    if($b=='' or null){
        if($method=='GET'){show_users();}
        elseif($method=='PUT'){set_user($input);}
        else{header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"Method $method not allowed here."]);}
        
    }else{
        if($method=='GET'){
        show_user($b);
        }else{header("HTTP/1.1 400 Bad Request");
            print json_encode(['errormesg'=>"Method $method not allowed here."]);}
    }
}


function handle_status($method) {
    if($method=='GET') {
        show_status();
    } else{
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Method $method not allowed here."]);
}
}

function handle_abort($method){
    if($method=='GET') {
        check_abort();
    } else{
        header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Method $method not allowed here."]);
}
}


function handle_board($method) {
    if($method=='GET') {
        show_board();
    } else if ($method=='POST') {
        reset_board();
    } else{header("HTTP/1.1 400 Bad Request");
        print json_encode(['errormesg'=>"Method $method not allowed here."]);}
}



?>  