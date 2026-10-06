<?php
$user = $_SERVER['argv'][1]; 
$password = $_SERVER['argv'][2]; 
$password_ma_hoa = password_hash($password, PASSWORD_DEFAULT);
file_put_contents('.password-giatuan.json',$password_ma_hoa);
file_put_contents('.user-giatuan.json',$user);
