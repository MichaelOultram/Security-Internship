<?php

  $target_dir = "C:\\wamp64\\www\\php_test\\Action\\uploads\\";
  $target_file = $target_dir . basename($_FILES["cv"]["name"]);
  $FileType = pathinfo($target_file,PATHINFO_EXTENSION);
  $uploadOk = 1;

  $name = $_POST['name'];
  $job = $_POST['job'];

  require_once('Action/PHPMailer-master/class.phpmailer.php');

  // Allow certain file formats
  if($FileType != "ods" || $FileType != "odt") {
      echo "<p>Sorry, only ODT/ODS files are allowed.</p>";
      $uploadOk = 0;
  }

  if($uploadOk == 0){
      echo "Your application could not be submitted. Please try again.";
  }
  else{
    if(move_uploaded_file($_FILES["cv"]["tmp_name"], $target_file)){

      echo "Form submitted!";
      $bodytext = "Hi. You have a new application from ".$name." for ".$job.". Find the cv attached.";
      $email = new PHPMailer();
      $email->From      = 'careers@worklink.vm';
      $email->FromName  = 'careers';
      $email->Subject   = 'New Application';
      $email->Body      = $bodytext;
      $email->AddAddress( 'c.hampshire@wokrlink.vm' );

      $file_to_attach = $_FILES["cv"]["name"];

      $email->AddAttachment( $file_to_attach , 'cv.pdf' );

      return $email->Send();
    }
    else{
      echo "There was a problem submitting your application. Please check your uploaded file and try again.";
    }
  }

 ?>
