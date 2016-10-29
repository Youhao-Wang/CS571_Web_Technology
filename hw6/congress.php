<!DOCTYPE HTML>
<HTML lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Homework #5 </title>
    <style>  
        form {border: 1px solid black; width: 290px;}  
        #output1 {width: 800px;
			margin: 0 auto;
			border: 1px solid;
			line-height: 20pt;
			text-align: center;
		}
        #output2 {
            width: 800px;
			margin: 0 auto;
			border: 1px solid;
			line-height: 20pt;
			text-align: center;
        }
        #innertable{
            width: 600px;
            border: 0px ;
            border-collapse: collapse;
            align : center;
        }
        .inner{
            width: 300px;
            border: 0px ;
            text-align: left;
        }
        table, td, th {
			border: 1px solid;}
		table {
			width: 800px;
			border-collapse: collapse;}
    </style>   
      <script type="text/javascript">

   function changeFunc() {
    var selectBox = document.getElementById("selectBox");
    var selectedValue = selectBox.options[selectBox.selectedIndex].value;
    if(selectedValue == "1")
        document.getElementById("keyword").innerHTML = "State/Representative*";
    else if (selectedValue == "2")
        document.getElementById("keyword").innerHTML = "Committee ID*";
    else if (selectedValue == "3")
        document.getElementById("keyword").innerHTML = "Bill ID* &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp";
    else if (selectedValue == "4")
        document.getElementById("keyword").innerHTML = "Amendment ID*";
   }
       /*   
    function formReset() {
        var el = document.getElementById("output_box1");
        el.parentNode.removeChild( el );
    }
    */
          
    function divRemove() {
         window.location.href = "congress.php";
    }
          
    function validateForm(){
        var databaseErr = document.forms["myform"]["database"].value;
        var textErr = document.forms["myform"]["text"].value;
        var content = "Please enter the following missing information:"
        var count = 0;
        
        if(databaseErr == "0"){
            content +="Congress database ";
            count ++;
        }
        if(textErr == null || textErr ==""|| textErr ==" "||textErr =="  "||textErr =="   "){
            content +=", keyword";
            count ++;
        }
        
        if(count != 0){
            alert(content);
            return false;
        }
    }
          
    </script>
       </head> 
        
    <body><center>
    
      <h2>Congress Information Search</h2>
        <form method="POST" name = "myform" onsubmit="return validateForm()" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
            
        Congress Database&nbsp <select  name="database" id="selectBox" onchange="changeFunc();" value="<?php echo $_POST["database"];?>">
            <option selected value = "0">Select your option</option>
            <option value = "1" <?php 
                    if (isset($_POST["database"]) && $_POST["database"] =="1") echo "selected"; 
                    if (isset($_GET["database"]) && $_GET["database"] =="1") echo "selected";?>>Legislators</option>
            <option value = "2" <?php 
                    if (isset($_POST["database"]) && $_POST["database"] =="2") echo "selected";
                    if (isset($_GET["database"]) && $_GET["database"] =="2") echo "selected";?>>Committees</option>
            <option value = "3" <?php 
                    if (isset($_POST["database"]) && $_POST["database"] =="3") echo "selected";
                    if (isset($_GET["database"]) && $_GET["database"] =="3") echo "selected";
                    ?>>Bills</option>
            <option value = "4" <?php 
                    if (isset($_POST["database"]) && $_POST["database"] =="4") echo "selected";
                    if (isset($_GET["database"]) && $_GET["database"] =="4") echo "selected";?>>Amendments</option>
            </select>   <br/>
        Chamber&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input type = "radio" name = "chamber"  value = "senate"  <?php if (isset($_POST["chamber"]) && $_POST["chamber"] =="senate") {echo "checked";} if (isset($_GET["inchamber"]) && $_GET["inchamber"] =="senate") {echo "checked";}?>  checked="checked">Senate
            <input type = "radio" name = "chamber"  value = "house" <?php if (isset($_POST["chamber"]) && $_POST["chamber"] =="house") echo "checked";if (isset($_GET["inchamber"]) && $_GET["inchamber"] =="house") echo "checked";?>>House  
         <br/>   
            
        <span id="keyword" >Keyword*&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>
        <input type = "text" name = "text"  autocomplete="on" value="<?php if(isset($_POST["text"])) {echo $_POST["text"];} if(isset($_GET["intext"])) {echo $_GET["intext"];} ?>"><br/>
            &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
            <input type = "submit" name = "search" value = "Search">
            <input type = "reset" name = "clear" value = "Clear" onclick="divRemove()"><br/>
            
        <a href="http://sunlightfoundation.com">Powered by Sunlight Foundation</a>         
        </form>
    
     </body>
        
        
        
        <?php    
        echo "<script> changeFunc() </script>";
        
        if($_SERVER["REQUEST_METHOD"] == "POST"){
        $address = $chamber = $text = $jsonContent = $database = $bioid = $billid = "";
        $database = $_POST["database"];
        $chamber = $_POST["chamber"];
        $text = $_POST["text"];
            
            if($database == "1"){
                $address .= "http://congress.api.sunlightfoundation.com/legislators?chamber=$chamber&";
                if($text == "Alabama" || $text =="Alaska" || $text =="Arizona" || $text     =="California"  ||$text =="Colorado" || $text =="Connecticut" || $text =="Delaware" || $text =="District Of         Columbia" ||$text =="New York" ||$text =="New Mexico" ||$text =="Montana" ||   $text ==  "Nebraska"||$text =="Nevada"||$text =="New Hampshire" || $text =="New Jersey" ||$text == "North Carolina" ||$text == "North Dakota" || $text == "Washington" || $text == "Florida"|| $text == "Georgia"|| $text == "Hawaii" || $text == "Idaho" || $text == "Illinois" || $text == "Indiana" || $text == "Iowa" || $text == "Kansas" || $text == "Kentucky" || $text == "Louisiana" || $text == "Maine" || $text == "Maryland" || $text == "Massachusetts" || $text == "Michigan" || $text == "Minnesota" || $text == "Mississippi" || $text == "Missouri" || $text == "Ohii" || $text == "Oklahoma" || $text == "Oregon" || $text == "Pennsylvania" || $text == "Rhode Island" || $text == "South Carolina"|| $text == "South Dakota"|| $text == "Tennessee"|| $text == "Texas"|| $text == "Utah" || $text == "Vermont"|| $text == "Virginia"|| $text == "West Virginia"|| $text == "Wisconsin" || $text == "Wyoming" ||$text == "alabama" || $text =="alaska" || $text =="arizona" || $text =="california"  ||$text =="colorado" || $text =="connecticut" || $text =="delaware" || $text =="district Of columbia" ||$text =="new York" ||$text =="new Mexico" ||$text =="montana" ||   $text ==  "nebraska"||$text =="evada"||$text =="new Hampshire" || $text =="new Jersey" ||$text == "north carolina" ||$text == "north Dakota" || $text == "washington" || $text == "florida"|| $text == "georgia"|| $text == "hawaii" || $text == "idaho" || $text == "illinois" || $text == "indiana" || $text == "Iowa" || $text == "kansas" || $text == "kentucky" || $text == "louisiana" || $text == "maine" || $text == "maryland" || $text == "massachusetts" || $text == "michigan" || $text == "minnesota" || $text == "mississippi" || $text == "missouri" || $text == "Ohii" || $text == "oklahoma" || $text == "oregon" || $text == "pennsylvania" || $text == "rhode Island" || $text == "south Carolina"|| $text == "south Dakota"|| $text == "tennessee"|| $text == "texas"|| $text == "utah" || $text == "vermont"|| $text == "virginia"|| $text == "west Virginia"|| $text == "wisconsin" || $text == "wyoming"){
                    $text = urlencode($text);
                    $address .= "state_name=$text&apikey=7d43d393c22b48bc8a831d1efe73532b"; 
                }
                else{
                    $text = urlencode($text);
                    $address .= "query=$text&apikey=7d43d393c22b48bc8a831d1efe73532b";
                }
                
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                  //  echo $_SERVER["PHP_SELF"];
                    echo "<br/><br/><br/>
                    <div id = 'output1'>
                        <table>
                            <tr>
                                <th>Name</th>
                                <th>State</th>
                                <th>Chamber</th>
                                <th>Details</th>
                            </tr>";
                    foreach($json -> results as $person){
                        $name = $person -> first_name;
                        $name .= " ";
                        $name .=$person -> last_name;
                        $state = $person -> state_name;
                        $cham = $person -> chamber;
                        $bioid = $person -> bioguide_id;
                        echo"<tr>";
                        echo"<td>  $name  </td>";
                        echo"<td>  $state  </td>";
                        echo"<td>  $cham  </td>";
                        echo '<td> <a href = "'.$_SERVER["PHP_SELF"]."?bioid=".$bioid."&intext=".$_POST['text']."&inchamber=".$_POST['chamber']."&database=".$_POST['database']."\"> View Details</a></td></tr>";
                        echo "</tr>";
                    }
                    echo "</table> </div>";
                }
                
            }
        
            
            else if($database == "2"){
                $address .="http://congress.api.sunlightfoundation.com/committees?committee_id=$text&chamber=$chamber&apikey=7d43d393c22b48bc8a831d1efe73532b";
                
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                 $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                    echo "<br/><br/><br/>
                    <div id = 'output1'>
                        <table>
                            <tr>
                                <th>Committee ID </th>";
                        echo   "<th>Committee Name </th>
                                <th> Chamber</th>
                            </tr>";
                    foreach($json -> results as $person){
                        $comid=$person -> committee_id;
                        $comname = $person -> name;
                        $cham = $person -> chamber;
                        echo"<tr>";
                        echo"<td>  $comid  </td>";
                        echo"<td>  $comname  </td>";
                        echo"<td>  $cham  </td>";
                        echo "</tr>";
                    }
                    echo "</table> </div>";
                }
            }
            
            else if($database == "3"){
                $address .="http://congress.api.sunlightfoundation.com/bills?bill_id=$text&chamber=$chamber&apikey=7d43d393c22b48bc8a831d1efe73532b";
                
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                    echo "<br/><br/><br/>
                    <div id = 'output1'>
                        <table>
                            <tr>
                                <th>Bill ID</th>
                                <th>Short Title</th>
                                <th>Chamber</th>
                                <th>Details</th>
                            </tr>";
                    foreach($json -> results as $person){
                        $bid = $person -> bill_id;
                        $st = $person -> short_title;
                        $cham = $person -> chamber;
                        echo"<tr>";
                        echo"<td>  $bid  </td>";
                        echo"<td>  $st  </td>";
                        echo"<td>  $cham  </td>";
                        echo '<td> <a href = "'.$_SERVER["PHP_SELF"]."?billid=".$bid."&intext=".$_POST['text']."&inchamber=".$_POST['chamber']."&database=".$_POST['database']."\"> View Details</a></td></tr>";
                        echo "</tr>";
                    }
                    echo "</table> </div>";
                }
            }
            
            else if($database == "4"){
                $address .="http://congress.api.sunlightfoundation.com/amendments?amendment_id=$text&chamber=$chamber&apikey=7d43d393c22b48bc8a831d1efe73532b";
                
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                 $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                    //echo $_SERVER["PHP_SELF"];
                    echo "<br/><br/><br/>
                    <div id = 'output1'>
                        <table>
                            <tr>
                                <th> Amendment ID </th>";
                        echo   "<th> Amendment Type </th>
                                <th> Chamber</th>
                                <th> Introduce on</th>
                            </tr>";
                    foreach($json -> results as $person){
                        $amid = $person -> amendment_id;
                        $amtype = $person -> amendment_type;
                        $cham = $person -> chamber;
                        $in = $person -> introduced_on;
                        echo"<tr>";
                        echo"<td>  $amid  </td>";
                        echo"<td>  $amtype  </td>";
                        echo"<td>  $cham  </td>";
                        echo"<td>  $in  </td>";
                        echo "</tr>";
                    }
                    echo "</table> </div>";
                }
            }       
        }
        
        if($_SERVER["REQUEST_METHOD"] == "GET"){
            $address = $jsonContent =  $bioid = $bid = "";
            $bioid = $_GET["bioid"];
            $bid = $_GET["billid"];
            
            if($_GET["database"] == 1){
                $address = "http://congress.api.sunlightfoundation.com/legislators?bioguide_id=$bioid&apikey=7d43d393c22b48bc8a831d1efe73532b";
                //echo $address;
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                    echo "  <br/><br/><br/>
                            <div id = 'output2'>";
                    echo "<br/> <image src = 'http://theunitedstates.io/images/congress/225x275/$bioid.jpg'> <br/>";
                    $fullname = $json -> results[0] -> title." ". $json -> results[0] -> first_name ." ". $json -> results[0] -> last_name;
                    $name1 = $json -> results[0] -> first_name ." ". $json -> results[0] -> last_name;
                    $name2 = $json -> results[0] -> first_name ." ". $json -> results[0] -> last_name;
                    $term = $json -> results[0] -> term_end;
                    
                    if($json -> results[0] -> website == null){
                        $web == "N.A.";
                    }
                    else{
                        $web = $json -> results[0] -> website;
                    }
                    $office = $json -> results[0] -> office;
                    
                    if($json -> results[0] -> facebook_id == null){
                        $name1 = "N.A.";
                    }
                    else{
                        $facebook = "http://www.facebook.com/" . $json -> results[0] -> facebook_id;
                    }
                     if($json -> results[0] -> twitter_id == null){
                        $name2 = "N.A.";
                    }
                    else{
                    $twitter = "http://twitter.com/" . $json -> results[0] -> twitter_id;
                    }
                    
                    echo "<table id = 'innertable' align='center'>";
                    echo "<tr class='inner'>
                            <td class='inner'> Full Name </td>
                            <td class='inner'> $fullname </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Term Ends on </td>
                            <td class='inner'> $term </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Website </td>
                            <td class='inner'> <a href = $web> $web </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Office </td>
                            <td class='inner'> $office </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Facebook </td>
                            <td class='inner'> <a href = $facebook> $name1 </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Twitter </td>
                            <td class='inner'> <a href = $twitter> $name2 </td>
                          </tr>";
                    echo "</table> </div>";              
                }
            }
            
            
            else if ($_GET["database"] == 3){
                $address = "http://congress.api.sunlightfoundation.com/bills?bill_id=$bid&chamber=senate&apikey=7d43d393c22b48bc8a831d1efe73532b";
                
                $jsonContent = file_get_contents($address);
                $json = json_decode($jsonContent);
                $count = $json -> count;
                if($count == 0)
                    echo "<br/><br/><br/> The API returned zero results for the request!";
                else{
                    echo "  <br/><br/><br/>
                            <div id = 'output2'>";
                    
                    $billTitle = $json -> results[0] -> short_title;
                    $sponsor = $json -> results[0] ->sponsor-> title ." ". $json ->             results[0] -> sponsor-> first_name." ". $json -> results[0] 
                        ->sponsor-> last_name;
                    $intro = $json -> results[0] -> introduced_on;
                    $last = $json -> results[0] -> last_version -> version_name .", ".$json     -> results[0] -> last_action_at;
                    $url = $json -> results[0] -> last_version -> urls -> pdf;
                    
                    
                    echo "<table id = 'innertable' align='center'>";
                    echo "<br/>";
                    echo "<tr class='inner'>
                            <td class='inner'> Bill ID </td>
                            <td class='inner'> $bid </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Bill Title </td>
                            <td class='inner'> $billTitle </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Sponsor </td>
                            <td class='inner'> $sponsor </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Introduced On </td>
                            <td class='inner'> $intro </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Last action with date </td>
                            <td class='inner'> $last </td>
                          </tr>
                          <tr class='inner'>
                            <td class='inner'> Bill URL </td>
                            <td class='inner'> <a href = $url> $billTitle </td>
                          </tr>";
                    echo "</table> </div>";              
                }
            }
        }

    ?>
        

</HTML>
</DOCTYPE>