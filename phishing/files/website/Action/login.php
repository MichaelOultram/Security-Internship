<?php

  $username = $_POST['usr'];
  $password = $_POST['psd'];

  if($username == "admin" && $password =="admin123"){
    header('Location: '. "../admin.html");
  }
  else{
    echo "Wrong credentials!";
  }
 ?>
