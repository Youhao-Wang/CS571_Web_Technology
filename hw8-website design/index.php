 <?php header('Access-Control-Allow-Origin: *'); 

 	if(isset($_GET['type'])){
 		$type =  $_GET['type'];
 		if($type == 1){  //Legislators
 			$url1 = "http://104.198.0.197:8080/legislators?apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=all";
		 	$file1 = file_get_contents($url1);
		 	$obj1 = json_decode($file1,true);
			$json_file1 = json_encode($obj1);
			echo $json_file1;
 		}
        
        else if($type == 12){  //Legislators_house
 			$url12 = "http://104.198.0.197:8080/legislators?chamber=house&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=all";
		 	$file12 = file_get_contents($url12);
		 	$obj12 = json_decode($file12,true);
			$json_file12 = json_encode($obj12);
			echo $json_file12;
 		}
        
         else if($type == 13){  //Legislators_senate
 			$url13 = "http://104.198.0.197:8080/legislators?chamber=senate&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=all";
		 	$file13 = file_get_contents($url13);
		 	$obj13 = json_decode($file13,true);
			$json_file13 = json_encode($obj13);
			echo $json_file13;
 		}


 		else if($type == 2){  //Active Bills		
			$url2 = "http://104.198.0.197:8080/bills?history.active=true&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=50";
		 	$file2 = file_get_contents($url2);
		 	$obj2 = json_decode($file2,true);
			$json_file2 = json_encode($obj2);
			echo $json_file2;
 		}

 		else if($type == 4){  //New Bills		
			$url4 = "http://104.198.0.197:8080/bills?history.active=false&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=50";
		 	$file4 = file_get_contents($url4);
		 	$obj4 = json_decode($file4,true);
			$json_file4 = json_encode($obj4);
			echo $json_file4;
 		}

 		else if($type == 3){  //Committees
			$url3 = "http://104.198.0.197:8080/committees?apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=all";
		 	$file3 = file_get_contents($url3);
		 	$obj3 = json_decode($file3,true);
			$json_file3 = json_encode($obj3);
			echo $json_file3;
 		}


 		else if($type == 5){  //detail_Committees
 			$bio_id = $_GET['bio_id'];
			$url5 = "http://104.198.0.197:8080/committees?member_ids=$bio_id&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=5";
		 	$file5 = file_get_contents($url5);
		 	$obj5 = json_decode($file5,true);
			$json_file5 = json_encode($obj5);
			echo $json_file5;
 		}


 		else if($type == 6){  //detail_Bills
 			$bio_id = $_GET['bio_id'];
			$url6 = "http://104.198.0.197:8080/bills?sponsor_id=$bio_id&apikey=7d43d393c22b48bc8a831d1efe73532b&per_page=5";
		 	$file6 = file_get_contents($url6);
		 	$obj6 = json_decode($file6,true);
			$json_file6 = json_encode($obj6);
			echo $json_file6;
 		}

 		
 		
 	}


 ?>