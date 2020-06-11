<?php

    date_default_timezone_set('Asia/Colombo');

    include 'connection/connection.php';

    $alert_msg = '';
    $alert_display = 'none';
    $alert_status = '';

    if (isset($_POST['submit_btn'])) {
        
        $customer_name = $_POST['customer_name'];
        $customer_email = $_POST['customer_email'];
        $customer_phone = $_POST['customer_phone'];
        $customer_date = $_POST['customer_date'];
        $type_of_room = $_POST['type_of_room'];
        $no_of_room = $_POST['no_of_room'];
        $customer_msg = $_POST['customer_msg'];
        
        $customer_room_book = "INSERT INTO `room_book`(`name`, `email`, `phone`, `check_in_date`, `type_of_room`, `no_of_room`, `message`) VALUES ('{$customer_name}', '{$customer_email}', '{$customer_phone}', '{$customer_date}', '{$type_of_room}', '{$no_of_room}', '{$customer_msg}')";

        $result_customer_room_book = mysqli_query($con,$customer_room_book);

        if ($result_customer_room_book) {
            $alert_display = 'block';
            $alert_status = 'success';
            $alert_msg = "Your reservation is successful...";
        } else {
            $alert_display = 'block';
            $alert_status = 'danger';
            $alert_msg = "Your reservation failed...";
        }
        
    }

?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <title>ChefGuru | Bandarawela</title>

        <!-- Google fonts -->
        <link href='http://fonts.googleapis.com/css?family=Raleway:300,500,800|Old+Standard+TT' rel='stylesheet' type='text/css'>
        <link href='http://fonts.googleapis.com/css?family=Raleway:300,500,800' rel='stylesheet' type='text/css'>

        <!-- font awesome -->
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
        
        <!-- bootstrap -->
        <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css" />

        <!-- uniform -->
        <link type="text/css" rel="stylesheet" href="assets/uniform/css/uniform.default.min.css" />

        <!-- animate.css -->
        <link rel="stylesheet" href="assets/wow/animate.css" />
        
        <!-- gallery -->
        <link rel="stylesheet" href="assets/gallery/blueimp-gallery.min.css">
        
        <!-- favicon -->
        <link rel="shortcut icon" href="images/logo.png" type="image/x-icon">
        <link rel="icon" href="images/logo.png" type="image/x-icon">

        <link rel="stylesheet" href="assets/style.css">

    </head>

    <body id="home">

        <!-- header -->
        <nav class="navbar  navbar-default" role="navigation">
            <div class="container">
                
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="index.php"><img src="images/logo_small.png"  alt="holiday crown"></a>
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse navbar-right" id="bs-example-navbar-collapse-1">

                    <ul class="nav navbar-nav">        
                        <li><a href="index.php">Home </a></li>
                        <li><a href="html/rooms-tariff.php">Rooms &amp; Tariff</a></li>        
                        <li><a href="html/introduction.php">Introduction</a></li>
                        <li><a href="html/gallery.php">Gallery</a></li>
                        <li><a href="html/contact.php">Contact</a></li>
                    </ul>
                </div><!-- Wnavbar-collapse -->
                
            </div><!-- container-fluid -->
        </nav>
        <!-- header -->
        
        <div class="container">
            <div class="row">
                <div class="alert alert-<?php echo $alert_status; ?>" role="alert" style="display: <?php echo $alert_display; ?>;">
                    <?php echo $alert_msg; ?>
                </div>
            </div>
        </div>

        <!-- banner -->
        <div class="banner">    	   
            <img src="images/homepage_banner.jpg"  class="img-responsive index_img" alt="slide">
            <div class="welcome-message">
                <div class="wrap-info">
                    <div class="information">
                        <h1  class="animated fadeInDown glow">Welcome to Chef Guru Hotel</h1>
                        <!--p class="animated fadeInUp">Most luxurious hotel of asia with the royal treatments and excellent customer service.</p-->                
                    </div>
                    <a href="#information" class="arrow-nav scroll wowload fadeInDownBig"><i class="fa fa-angle-down"></i></a>
                </div>
            </div>
        </div>
        <!-- banner-->


        <!-- reservation-information -->
        <div id="information" class="spacer reserve-info ">
            <div class="container">
                <div class="row">

                    <div class="col-sm-7 col-md-8">

                        <div class="embed-responsive embed-responsive-16by9 wowload fadeInLeft">
                            <img  class="embed-responsive-item" src="images/index_img.jpg" width="100%" height="400" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen>
                        </div>
                    </div>

                    <div class="col-sm-5 col-md-4">
                        <h3>Reservation</h3>

                        <form role="form" class="wowload fadeInRight" action="index.php" method="post">
                            <div class="form-group">
                                <input type="text" name="customer_name" class="form-control"  placeholder="Name" required maxlength="50">
                            </div>
                            <div class="form-group">
                                <input type="email" name="customer_email" class="form-control"  placeholder="Email" required maxlength="50">
                            </div>
                            <div class="form-group">
                                <input type="tel" name="customer_phone" class="form-control"  placeholder="Phone" required maxlength="20">
                            </div>
                            <div class="form-group">
                                <input type="date" name="customer_date" class="form-control"  placeholder="Date" required min="<?php echo date('Y-m-d', strtotime(' +1 day')); ?>">
                            </div>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-xs-6">
                                        <select class="form-control" name="type_of_room" required>
                                            <option value="1">Type of Rooms</option>
                                            <?php

                                                $get_rooms_details = "SELECT * FROM `room_type` WHERE `is_deleted` = 0";

                                                $result_rooms_details = mysqli_query($con,$get_rooms_details);

                                                if (mysqli_num_rows($result_rooms_details) > 0) {

                                                    while($row_rooms_details = mysqli_fetch_assoc($result_rooms_details)) {

                                            ?>
                                            <option value="<?php echo $row_rooms_details['id']; ?>"><?php echo $row_rooms_details['type']; ?></option>
                                            <?php
                                                    }
                                                }
                                            ?>
                                            
                                        </select>
                                    </div>
                                    
                                    <div class="col-xs-6">
                                        <select class="form-control" name="no_of_room" required>
                                            <option value="1">No. of Rooms</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <textarea class="form-control" name="customer_msg"  placeholder="Message" rows="4" maxlength="500"></textarea>
                            </div>
                            <button class="btn btn-default" type="submit" name="submit_btn">Submit</button>
                        </form>  

                    </div>
                </div>  
            </div>
        </div>
        <!-- reservation-information -->



        <!-- services -->
        <div class="spacer services wowload fadeInUp">
            <div class="container">
                <div class="row">

                    <div class="col-sm-4">
                        <!-- RoomCarousel -->
                        <div id="RoomCarousel" class="carousel slide" data-ride="carousel">
                            <div class="carousel-inner">
                                <div class="item active"><img src="images/gallery/room1.jpg" class="img-responsive" alt="slide"></div>
                                <div class="item  height-full"><img src="images/gallery/room2.jpg"  class="img-responsive" alt="slide"></div>
                                <div class="item  height-full"><img src="images/gallery/room3.jpg"  class="img-responsive" alt="slide"></div>
                            </div>
                            <!-- Controls -->
                            <a class="left carousel-control" href="#RoomCarousel" role="button" data-slide="prev"><i class="fa fa-angle-left"></i></a>
                            <a class="right carousel-control" href="#RoomCarousel" role="button" data-slide="next"><i class="fa fa-angle-right"></i></a>
                        </div>
                        <!-- RoomCarousel-->
                        <div class="caption">Rooms<a href="html/rooms-tariff.php" class="pull-right"><i class="fa fa-arrow-circle-right"></i></a></div>
                    </div>

                    <div class="col-sm-4">
                        <!-- RoomCarousel -->
                        <div id="TourCarousel" class="carousel slide" data-ride="carousel">
                            <div class="carousel-inner">
                                <div class="item active"><img src="images/gallery/service1.jpg" class="img-responsive" alt="slide"></div>
                                <div class="item  height-full"><img src="images/gallery/service2.jpg"  class="img-responsive" alt="slide"></div>
                            </div>
                            <!-- Controls -->
                            <a class="left carousel-control" href="#TourCarousel" role="button" data-slide="prev"><i class="fa fa-angle-left"></i></a>
                            <a class="right carousel-control" href="#TourCarousel" role="button" data-slide="next"><i class="fa fa-angle-right"></i></a>
                        </div>
                        <!-- RoomCarousel-->
                        <div class="caption">Services<a href="html/gallery.php" class="pull-right"><i class="fa fa-arrow-circle-right"></i></a></div>
                    </div>


                    <div class="col-sm-4">
                        <!-- RoomCarousel -->
                        <div id="FoodCarousel" class="carousel slide" data-ride="carousel">
                            <div class="carousel-inner">
                                <div class="item active"><img src="images/gallery/food1.jpg" class="img-responsive" alt="slide"></div>
                                <div class="item  height-full"><img src="images/gallery/food2.jpg"  class="img-responsive" alt="slide"></div>
                                <div class="item  height-full"><img src="images/gallery/food3.jpg"  class="img-responsive" alt="slide"></div>
                            </div>
                            <!-- Controls -->
                            <a class="left carousel-control" href="#FoodCarousel" role="button" data-slide="prev"><i class="fa fa-angle-left"></i></a>
                            <a class="right carousel-control" href="#FoodCarousel" role="button" data-slide="next"><i class="fa fa-angle-right"></i></a>
                        </div>
                        <!-- RoomCarousel-->
                        <div class="caption">Food and Drinks<a href="html/gallery.php" class="pull-right"><i class="fa fa-arrow-circle-right"></i></a></div>
                    </div>

                </div>
            </div>
        </div>
        <!-- services -->
        
        
        <footer class="spacer">
            <div class="container">
                <div class="row">

                    <div class="col-sm-5">
                        <!--h4>Chef Guru</h4-->
                        <img src="images/logo.png">
                    </div> 

                    <div class="col-sm-3">
                        <h4>Quick Links</h4>
                        <ul class="list-unstyled">
                            <li><a href="html/rooms-tariff.php">Rooms &amp; Tariff</a></li>        
                            <li><a href="html/introduction.php">Introduction</a></li>
                            <li><a href="html/gallery.php">Gallery</a></li>
                            <li><a href="html/contact.php">Contact</a></li>
                        </ul>
                    </div>

                    <div class="col-sm-4 subscribe">
                        <!--h4>Subscription</h4>
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Enter email id here">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">Get Notify</button>
                            </span>
                        </div-->
                        <ul class="list-unstyled">
                            <li><a>+94 57 22 30 500</a></li>
                            <li><a>mevangurusinghe2@gmail.com</a></li>
                            <li><a>Sri Sangharaja Piriwena Road, Lower Kahattewela, Bandarawela, 90100. Sri Lanka.</a></li>
                        </ul>
                        <div class="social">
                            <a href="https://www.facebook.com/Villa-di-Sara-873068492801765/" target="_blank"><i class="fa fa-facebook-square" data-toggle="tooltip" data-placement="top" data-original-title="facebook"></i></a>
                            <a href="https://www.instagram.com/explore/locations/1998277737108074/villa-di-sara/" target="_blank"><i class="fa fa-instagram"  data-toggle="tooltip" data-placement="top" data-original-title="instragram"></i></a>
                            <!--a href="#" target="_blank"><i class="fa fa-twitter-square" data-toggle="tooltip" data-placement="top" data-original-title="twitter"></i></a>
                            <a href="#" target="_blank"><i class="fa fa-pinterest-square" data-toggle="tooltip" data-placement="top" data-original-title="pinterest"></i></a>
                            <a href="#" target="_blank"><i class="fa fa-tumblr-square" data-toggle="tooltip" data-placement="top" data-original-title="tumblr"></i></a>
                            <a href="#" target="_blank"><i class="fa fa-youtube-square" data-toggle="tooltip" data-placement="top" data-original-title="youtube"></i></a-->
                        </div>
                    </div>

                </div>
                <!--/.row--> 
            </div>
            <!--/.container-->    
            <!--/.footer-bottom--> 
        </footer>

        <div class="text-center copyright">Powered by <a>Team Semicolon;</a></div>

        <a href="#home" class="toTop scroll"><i class="fa fa-angle-up"></i></a>
        <!-- The Bootstrap Image Gallery lightbox, should be a child element of the document body -->

        <div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls">
            <!-- The container for the modal slides -->
            <div class="slides"></div>
            <!-- Controls for the borderless lightbox -->
            <h3 class="title">title</h3>
            <a class="prev">‹</a>
            <a class="next">›</a>
            <a class="close">×</a>
            <!-- The modal dialog, which will be used to wrap the lightbox content -->    
        </div>

        <script src="assets/jquery.js"></script>

        <!-- wow script -->
        <script src="assets/wow/wow.min.js"></script>

        <!-- uniform -->
        <script src="assets/uniform/js/jquery.uniform.js"></script>

        <!-- boostrap -->
        <script src="assets/bootstrap/js/bootstrap.js" type="text/javascript" ></script>

        <!-- jquery mobile -->
        <script src="assets/mobile/touchSwipe.min.js"></script>

        <!-- jquery mobile -->
        <script src="assets/respond/respond.js"></script>

        <!-- gallery -->
        <script src="assets/gallery/jquery.blueimp-gallery.min.js"></script>

        <!-- custom script -->
        <script src="assets/script.js"></script>

    </body>
</html>