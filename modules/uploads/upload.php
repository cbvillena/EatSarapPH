<?php
//echo nl2br(print_r($_FILES,1));
$temp = explode(".", $_FILES["file"]["name"]);
$newfilename = round(microtime(true)) . '.' . end($temp);
move_uploaded_file($_FILES["file"]["tmp_name"], "upload/" . $_POST["identity"].$newfilename);
echo json_encode($_POST["identity"].$newfilename);
?>
