<?php
$plain_password = 'Maharoof47a@'; // Change this to your desired password
$hashed_password = password_hash($plain_password, PASSWORD_BCRYPT);
echo "Hashed password: " . $hashed_password;
?>