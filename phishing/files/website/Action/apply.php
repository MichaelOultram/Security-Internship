<?php

  $target_dir = "/var/www/html/Action/uploads/";
  $target_file = $target_dir . basename($_FILES["cv"]["name"]);
  $FileType = pathinfo($target_file,PATHINFO_EXTENSION);
  $uploadOk = 1;

  // Allow certain file formats
  if($FileType != "pdf" ) {
      echo "<p>Sorry, only PDF files are allowed.</p>";
      $uploadOk = 0;
  }

  if($uploadOk == 0){
      echo "Your application could not be submitted. Please try again.";
  }
  else{
    if(move_uploaded_file($_FILES["cv"]["tmp_name"], $target_file)){
      echo "Form submitted!";
    }
    else{
      echo "There was a problem submitting your application. Please check your uploaded file and try again.";
    }
  }

 ?>
