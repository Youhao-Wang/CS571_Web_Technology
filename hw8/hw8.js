
 	var myApp = angular.module('myApp', ['angularUtils.directives.dirPagination','ui.bootstrap']);

	/*var committee_list = [];
	committee_list.push(JSON.parse(localStorage.getItem("favorite_committees")));
	localStorage.setItem('favorite_committees', JSON.stringify(committee_list));
	*/

    myApp.controller('MyController', MyController);
    function MyController($scope, $http) {

    	$scope.items = [];
    	$http({
	        method : "GET",
	        params: {type: 1},
	        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
	    }).then(function mySucces(response1) {
	        $scope.items = response1.data.results;
	    }, function myError(response1) {
	        alert(error);
	    });



	    $scope.bills = []; 
	    $http({
	        method : "GET",
	        params: {type: 2},
	        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
	    }).then(function mySucces(response2) {
	        $scope.bills = response2.data.results;
	    }, function myError(response2) {
	        alert(error);
	    });



	    $scope.newbills = []; 
	    $http({
	        method : "GET",
	        params: {type: 4},
	        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
	    }).then(function mySucces(response4) {
	        $scope.newbills = response4.data.results;
	    }, function myError(response4) {
	        alert(error);
	    });


	    $scope.committees = [];
	     $http({
	        method : "GET",
	        params: {type: 3},
	        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
	    }).then(function mySucces(response3) {
	        $scope.committees = response3.data.results;
	    }, function myError(response3) {
	        alert(error);
	    });




	    $scope.legislator = "";
	    $scope.view_detail1 = function($item)
		{
			$("#myCarousel1").carousel(1);
			$("#myCarousel1").carousel('pause');
			$scope.legislator = $item;
			//alert("item": $item);
			//legislator_detail = $item;
			
			var begin_ms = Date.parse(new Date($item.term_start.replace(/-/g,"/") ) );
			var end_ms = Date.parse(new Date($item.term_end.replace(/-/g,"/") ) );
			var myDate = new Date();
			var myCur = myDate.toLocaleDateString();
			var mydate_ms = Date.parse(myCur);
			$scope.term = Math.round(100 * (mydate_ms - begin_ms)/(end_ms -begin_ms));


            $scope.detail_coms =[];
	   		$http({
		        method : "GET",
		        params: {type: 5,
		        		 bio_id: $item.bioguide_id
		        		},
		        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
		    }).then(function mySucces(response5) {
		        $scope.detail_coms = response5.data.results;
		    }, function myError(response5) {
		        alert(error);
		    });

            
            $scope.detail_bills=[];
		    $http({
		        method : "GET",
		        params: {type: 6,
		        		 bio_id: $item.bioguide_id
		        		},
		        url : "http://youhao.eypfwwr7rx.us-west-2.elasticbeanstalk.com/"
		    }).then(function mySucces(response6) {
		        $scope.detail_bills = response6.data.results;
		    }, function myError(response6) {
		        alert(error);
		    });


		    //the color of star
		    $(document).ready(function(){
			    var legislator_list = [];
			    var star = document.getElementById($item.bioguide_id);
				legislator_list = JSON.parse(localStorage.getItem("favorite_legislators"));
				var index = legislator_list.map(function(d) { return d['bioguide_id']; }).indexOf($item.bioguide_id);
				if (index < 0) {
				    star.setAttribute("class","fa fa-star-o");
					star.setAttribute("style","");
				}
				else{
					star.setAttribute("class","fa fa-star");
					star.setAttribute("style","color:yellow");
				}
			})
		}



		/*   favorite_legislator !     */
 		localStorage.clear();
 		if(localStorage.getItem("favorite_legislators") === null){
			var legislator_list  = [];
			localStorage.setItem("favorite_legislators",JSON.stringify(legislator_list));
		}
 		var legislator_list = [];
 		legislator_list = JSON.parse(localStorage.getItem("favorite_legislators"));				
		$scope.favorite_legislators = legislator_list ;


 		$scope.favorite_legislator = function($legislator){
			var star = document.getElementById($legislator.bioguide_id);
			var legislator_list = [];
			legislator_list = JSON.parse(localStorage.getItem("favorite_legislators"));
			var index = legislator_list.map(function(d) { return d['bioguide_id']; }).indexOf($legislator.bioguide_id);


			if(index > -1){
				star.setAttribute("class","fa fa-star-o");
				star.setAttribute("style","");
				legislator_list.splice(index, 1);
				localStorage.setItem("favorite_legislators",JSON.stringify(legislator_list)); 
				$scope.favorite_legislators = legislator_list ;
			}

			else{
				star.setAttribute("class","fa fa-star");
				star.setAttribute("style","color:yellow");			
				legislator_list.push($legislator);
				localStorage.setItem("favorite_legislators",JSON.stringify(legislator_list)); 
				$scope.favorite_legislators = legislator_list ;
			}
		}



		 $scope.delete_legislator = function($legislator){
			var legislator_list = [];
			legislator_list = JSON.parse(localStorage.getItem("favorite_legislators"));
			var index = legislator_list.map(function(d) { return d['bioguide_id']; }).indexOf($legislator.bioguide_id);
			if (index > -1) {
			    legislator_list.splice(index, 1);
			}
			localStorage.setItem("favorite_legislators",JSON.stringify(legislator_list)); 
			$scope.favorite_legislators = legislator_list ;
		}    






	    $scope.view_detail2 = function($bill)
		{
			$("#myCarousel2").carousel(1);
			$("#myCarousel2").carousel('pause');

			$scope.bill_detail = $bill;
			$(document).ready(function(){
			    var bill_list = [];
			    var star = document.getElementById($bill.bill_id);
				bill_list = JSON.parse(localStorage.getItem("favorite_bills"));
				var index = bill_list.map(function(d) { return d['bill_id']; }).indexOf($bill.bill_id);
				if (index < 0) {
				    star.setAttribute("class","fa fa-star-o");
					star.setAttribute("style","");
				}
				else{
					star.setAttribute("class","fa fa-star");
					star.setAttribute("style","color:yellow");
				}
			})
		}





		/*   favorite_bill !     */
 		//localStorage.clear();
 		if(localStorage.getItem("favorite_bills") === null){
			var bill_list  = [];
			localStorage.setItem("favorite_bills",JSON.stringify(bill_list));
		}
 		var bill_list = [];
 		bill_list = JSON.parse(localStorage.getItem("favorite_bills"));				
		$scope.favorite_bills = bill_list ;

 		$scope.favorite_bill = function($bill){
			var star = document.getElementById($bill.bill_id);
			var bill_list = [];
			bill_list = JSON.parse(localStorage.getItem("favorite_bills"));
			var index = bill_list.map(function(d) { return d['bill_id']; }).indexOf($bill.bill_id);



			if(index > -1){
				star.setAttribute("class","fa fa-star-o");
				star.setAttribute("style","");
				bill_list.splice(index, 1);
				localStorage.setItem("favorite_bills",JSON.stringify(bill_list)); 
				$scope.favorite_bills = bill_list ;
			}

			else{
				star.setAttribute("class","fa fa-star");
				star.setAttribute("style","color:yellow");			
				bill_list.push($bill);
				localStorage.setItem("favorite_bills",JSON.stringify(bill_list)); 
				$scope.favorite_bills = bill_list ;
			}
		}



		 $scope.delete_bill = function($bill){

			var bill_list = [];
			bill_list = JSON.parse(localStorage.getItem("favorite_bills"));
			var index = bill_list.map(function(d) { return d['bill_id']; }).indexOf($bill.bill_id);
			if (index > -1) {
			    bill_list.splice(index, 1);
			}
			localStorage.setItem("favorite_bills",JSON.stringify(bill_list)); 
			$scope.favorite_bills = bill_list ;
		}    







	    $scope.go_back1 = function(){
	    	$("#myCarousel1").carousel(0);
			$("#myCarousel1").carousel('pause');
		}

		$scope.go_back2 = function(){
	    	$("#myCarousel2").carousel(0);
			$("#myCarousel2").carousel('pause');
		}

 		
		/*   favorite_committees !     */
 		//localStorage.clear();
 		if(localStorage.getItem("favorite_committees") === null){
			var committee_list  = [];
			localStorage.setItem("favorite_committees",JSON.stringify(committee_list));
		}
 		var committee_list = [];
 		committee_list = JSON.parse(localStorage.getItem("favorite_committees"));				
		$scope.favorite_committees = committee_list ;

 		$scope.favorite_committee = function($committee){
			var star = document.getElementById($committee.committee_id);
			var classname = star.getAttribute("class");
			if(classname == "fa fa-star"){
				star.setAttribute("class","fa fa-star-o");
				star.setAttribute("style","");
				var committee_list = [];
				committee_list = JSON.parse(localStorage.getItem("favorite_committees"));
				var index = committee_list.map(function(d) { return d['committee_id']; }).indexOf($committee.committee_id);
				if (index > -1) {
				    committee_list.splice(index, 1);
				}
				localStorage.setItem("favorite_committees",JSON.stringify(committee_list)); 
				$scope.favorite_committees = committee_list ;
			}

			else{
				star.setAttribute("class","fa fa-star");
				star.setAttribute("style","color:yellow");
				var committee_list = [];
				committee_list = JSON.parse(localStorage.getItem("favorite_committees"));				
				committee_list.push($committee);
				localStorage.setItem("favorite_committees",JSON.stringify(committee_list)); 
				$scope.favorite_committees = committee_list ;
			}
		}



		 $scope.delete_committee = function($committee){
		 	var star = document.getElementById($committee.committee_id);
		 	star.setAttribute("class","fa fa-star-o");
			star.setAttribute("style","");

			var committee_list = [];
			committee_list = JSON.parse(localStorage.getItem("favorite_committees"));
			var index = committee_list.map(function(d) { return d['committee_id']; }).indexOf($committee.committee_id);
			if (index > -1) {
			    committee_list.splice(index, 1);
			}
			localStorage.setItem("favorite_committees",JSON.stringify(committee_list)); 
			$scope.favorite_committees = committee_list ;
		}    

}



	$(document).ready(function(){
		//to hide the navigation bar
	    $("#hide").click(function(){
	    	 $(".whole_content").toggleClass("change col-md-12");
	        $("#navigation_bar").toggle();
	    });

	});

	
	function click_legis(){
		document.getElementById("Legislators").style.display = "block";
		document.getElementById("Bills").style.display = "none";
		document.getElementById("Committees").style.display = "none";
        document.getElementById("Favorites").style.display = "none";
    //    document.getElementById("Legislators_detail").style.display = "none";
    //    document.getElementById("Bills_detail").style.display = "none";
	}

	function click_bills(){
		document.getElementById("Legislators").style.display = "none";
		document.getElementById("Bills").style.display = "block";
		document.getElementById("Committees").style.display = "none";
        document.getElementById("Favorites").style.display = "none";
    //    document.getElementById("Legislators_detail").style.display = "none";
    //    document.getElementById("Bills_detail").style.display = "none";
	}

	function click_commit(){
		document.getElementById("Legislators").style.display = "none";
		document.getElementById("Bills").style.display = "none";
		document.getElementById("Committees").style.display = "block";
        document.getElementById("Favorites").style.display = "none";
    //    document.getElementById("Legislators_detail").style.display = "none";
    //    document.getElementById("Bills_detail").style.display = "none";
	}

	function click_favo(){
		document.getElementById("Legislators").style.display = "none";
		document.getElementById("Bills").style.display = "none";
		document.getElementById("Committees").style.display = "none";
        document.getElementById("Favorites").style.display = "block";
    //    document.getElementById("Legislators_detail").style.display = "none";
    //    document.getElementById("Bills_detail").style.display = "none";
	}





	





