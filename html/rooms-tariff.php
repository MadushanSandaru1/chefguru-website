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

                <!--img src="" class="img-responsive"-->

                <div class="info">
                    <h3><?php echo $row_rooms_details['type']; ?></h3>
                    <p><?php echo $row_rooms_details['description']; ?></p>
                    <a class="btn btn-default">Price: LKR <?php echo number_format($row_rooms_details['rate'],2); ?></a>
                </div>

            </div>
        </div>
        
        <?php
                
                }

            } else {
        ?>
        
        <div class="col-sm-6 wowload fadeInUp">
            <div class="rooms">
                
                <div class="info">
                    <h3>There is no room description</h3>
                </div>

            </div>
        </div>
        
        <?php
                
            }

        ?>
    
    </div>

</div>

<?php include 'footer.php'; ?>