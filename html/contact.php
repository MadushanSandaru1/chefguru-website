<?php include 'header.php'; ?>

<?php

    include '../connection/connection.php';

    $alert_msg = '';
    $alert_display = 'none';
    $alert_status = '';

    if (isset($_POST['submit_msg'])) {
        
        $customer_name = $_POST['customer_name'];
        $customer_email = $_POST['customer_email'];
        $customer_phone = $_POST['customer_phone'];
        $customer_msg = $_POST['customer_msg'];
        
        $customer_message = "INSERT INTO `customer_message` (`name`, `email`, `phone`, `message`) VALUES ('{$customer_name}', '{$customer_email}', '{$customer_phone}', '{$customer_msg}')";

        $result_customer_message = mysqli_query($con,$customer_message);

        if ($result_customer_message) {
            $alert_display = 'block';
            $alert_status = 'success';
            $alert_msg = "Your message was sent successfully...";
        } else {
            $alert_display = 'block';
            $alert_status = 'danger';
            $alert_msg = "Failed to send your message...";
        }
        
        /* require '../email/PHPMailerAutoload.php';
        $credential = include('../email/credential.php');   //credentials import

        $mail = new PHPMailer;
            //$mail->SMTPDebug = 3;                               // Enable verbose debug output
        $mail->isSMTP();                                      // Set mailer to use SMTP
        $mail->Host = 'smtp.gmail.com';  // Specify main and backup SMTP servers
        $mail->SMTPAuth = true;                               // Enable SMTP authentication
        $mail->Username = $credential['user']  ;           // SMTP username
        $mail->Password = $credential['pass']  ;                           // SMTP password
        $mail->SMTPSecure = 'tls';                            // Enable TLS encryption, `ssl` also accepted
        $mail->Port = 587;                                    // TCP port to connect to

        $mail->setFrom($email);
        $mail->addAddress($email);             // Name is optional

        $mail->addReplyTo('hello');

        $mail->isHTML(true);                                  // Set email format to HTML
        $send1="";
        $send2="";
        $pw="Your password is : ".$pwd;
        $mail->Subject = "Password";
        $mail->Body    = "$pw<br>";
        $mail->AltBody = 'If you see this mail. please reload the page.';

        if(!$mail->send()) {
            echo 'Message could not be sent.';
            echo 'Mailer Error: ' . $mail->ErrorInfo;
        }else{
            echo "<script>alert('Your password send your Email')</script>";
        }*/
        
    }

?>

<div class="container">

    <h1 class="title">Contact</h1>
    
    <div class="alert alert-<?php echo $alert_status; ?>" role="alert" style="display: <?php echo $alert_display; ?>;">
        <?php echo $alert_msg; ?>
    </div>
    
    <!-- form -->
    <div class="contact">
        <div class="row">
            
            <div class="col-sm-12">
                
                <div class="map">
                    <div class="mapouter">
                        <div class="gmap_canvas">
                            <iframe width="1080" height="400" id="gmap_canvas" src="https://maps.google.com/maps?q=chef%20guru%20hotel%20bandarawela&t=&z=13&ie=UTF8&iwloc=&output=embed" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
                            <a href="https://www.divi-discount.com/en/">divi discount</a>
                        </div>
                        <style>
                            .mapouter{position:relative;text-align:right;height:400px;width:1080px;}.gmap_canvas {overflow:hidden;background:none!important;height:400px;width:1080px;}
                        </style>
                    </div>
                </div>


                <div class="col-sm-6 col-sm-offset-3">
                    <div class="spacer">
                        
                        <h4>Write to us</h4>
                        
                        <form role="form" action="contact.php" method="post">
                            <div class="form-group">	
                                <input type="text" name="customer_name" class="form-control" id="name" placeholder="Name" required maxlength="50">
                            </div>
                            
                            <div class="form-group">
                                <input type="email" name="customer_email" class="form-control" id="email" placeholder="Enter email" required maxlength="50">
                            </div>
                            
                            <div class="form-group">
                                <input type="phone" name="customer_phone" class="form-control" id="phone" placeholder="Phone" required maxlength="20">
                            </div>
                            
                            <div class="form-group">
                                <textarea type="text" name="customer_msg" class="form-control"  placeholder="Message" rows="4" required maxlength="500"></textarea>
                            </div>

                            <button type="submit" name="submit_msg" class="btn btn-default">Send</button>
                        </form>
                        
                    </div>
                </div>
                
            </div>
            
        </div>
    </div>
    <!-- form -->

</div>

<?php include 'footer.php'; ?>