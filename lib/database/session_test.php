<?php
session_start();
echo "Session ID: " . session_id() . "<br>";
echo "Session save path: " . session_save_path() . "<br>";

$_SESSION['test'] = 'This is a test value';
echo "Session test value: " . $_SESSION['test'] . "<br>";

echo "All session data: <pre>";
print_r($_SESSION);
echo "</pre>";
?>