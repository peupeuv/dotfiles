<?php
require_once('path/to/wp-load.php'); // Replace with the actual path to your wp-load.php file

// Set the email variables
$to = 'recipient';
$subject = 'Hello from WordPress';
$message = 'This is a test email sent using wp_mail_smtp.';
$headers = array('Content-Type: text/html; charset=UTF-8');

// Use the wp_mail function with the SMTP settings
add_action('phpmailer_init', 'configure_smtp');
function configure_smtp($phpmailer) {
    $phpmailer->isSMTP();
    $phpmailer->Host = 'smtp.gmail.com'; // Replace with your SMTP host
    $phpmailer->Port = 587; // Replace with your SMTP port (e.g., 465 for SSL)
    $phpmailer->SMTPSecure = 'tls'; // Replace with the encryption type (tls or ssl)
    $phpmailer->SMTPAuth = true;
    $phpmailer->Username = 'user'; // Replace with your Gmail email address
    $phpmailer->Password = 'passwd'; // Replace with your Gmail password
}

// Send the email using wp_mail
$result = wp_mail($to, $subject, $message, $headers);

// Check if the email was sent successfully
if ($result) {
    echo 'Email sent successfully!';
} else {
    echo 'Email failed to send.';
}
?>
