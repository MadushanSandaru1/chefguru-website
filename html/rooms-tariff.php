<?php include 'header.php'; ?>

<?php

    include '../connection/connection.php';

?>

<div class="container">
    
    <h2>Rooms &amp; Tariff</h2>
    
    <div class="row">
        
        <?php

            $get_rooms_details = "SELECT * FROM `room_type` WHERE `is_deleted` = 0";

            $result_rooms_details = mysqli_query($con,$get_rooms_details);

            if (mysqli_num_rows($result_rooms_details) > 0) {

                while($row_rooms_details = mysqli_fetch_assoc($result_rooms_details)) {
        
        ?>
    
        <div class="col-sm-6 wowload fadeInUp">
            <div class="rooms">

                <img src="../images/room_type/<?php echo $row_rooms_details['image']; ?>" class="img-responsive">

                <div class="info">
                    <h3><?php echo $row_rooms_details['type']; ?></h3>
                    <p><?php echo $row_rooms_details['description']; ?></p>
                    <a class="btn btn-default">Price: $ <?php echo $row_rooms_details['price']; ?></a>
                </div>

            </div>
        </div>
        
        <?php
                
                }

            } else {
        ?>
        
        <div class="col-sm-6 wowload fadeInUp">
            <div class="rooms">

                <a class="btn btn-default">There is no room description</a>

            </div>
        </div>
        
        <?php
                
            }

        ?>
    
    </div>

</div>

<?php include 'footer.php'; ?>