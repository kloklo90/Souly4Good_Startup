$(document).ready(function(){
	//create post page

	if($('#create_post').length > 0)
	{

	}

	$('.datetimepicker').datetimepicker({
		format: 'dddd, MMMM Do YYYY, H:mm:ss ZZ'
	});


	//Add Friends widget
	$("#add_friend_btn").click(function(e) {
			e.preventDefault();
			// show submit button
			$('#submit_friend_btn').show();

		$("#friend_list").append( "<span class='friend_input_wrapper'> <input class='friend_email_input form_control' name='user_emails[]' placeholder=\"Enter your buddy's email \"/> <a class='friend_cancel'>X</a></span> " );
		
		//Unbind previous click event
		$(".friend_input_wrapper > .friend_cancel ").off('click');

		//Bind click event
		$(".friend_input_wrapper > .friend_cancel ").on('click',function(e){
			$(this).parent( ".friend_input_wrapper" ).remove();
		});

	});

	

	$('#submit_friend_btn').click(function(e) {
		// ajax call to send invitations
		var user_emails = [];
		$('.friend_email_input').each(function(element){
			if ($( this ).val() != "") {
				user_emails.unshift($( this ).val());	
			};
			

		});
		
		if (user_emails.length > 0 ) {
			$.ajax({
			  type: "POST",
			  url: "/batch_invite",
			  data: { user_emails : user_emails},
			  success: function  (res) {
			  	// Update dom elements to current values
			  	$("#friend_list").html("<p>Invite successful</p>");
			  	$("#progress_level").html(res.progess_level+"%");
			  	$("#progress_name").html(res.progess_name);


			  }
			});
		};
		
	});

})





var PostsModel = function() {
	self = this;

	this.initLoadMore = function(){

		$(".ui.cards").infinitescroll({
		    navSelector: ".pagination" ,
		    nextSelector: ".pagination a[rel=next]",
		    itemSelector: ".card",
		},function( newElements ) {
	    var $newElems = $( newElements );
	    self.$grid.masonry( 'appended', $newElems );
	     self.$grid.masonry('layout');
	  });


		/*$('.load-more').on('click', function(){
			var elem = $(this);
			var spinner = elem.find('.fa-spin');
			var page_num = elem.data('page') + 1;
			spinner.removeClass('hide');
			$.get( "", {page: page_num}, 
			function( data ) {
				//console.log(data);
			 //$('.ui.cards').append(data);
			self.$grid.append( $(data) );
			self.$grid.masonry( 'appended', $(data) ).masonry();
			 console.log( self.$grid );

			 //self.$grid.masonry('reloadItems');
			 self.$grid.masonry('layout');
			 spinner.addClass('hide');
			 console.log ( elem.data('page'));
			 elem.data('page', page_num);
			})
			.fail(function(){
				console.log('error');
				spinner.addClass('hide');
			});
		})*/
	}

	this.init = function( opts ){

		//self.$grid = $('#con');
	    self.$grid = $('#con').masonry({
	      // options
	      itemSelector: '.card',
	      columnWidth: '.card',
	      gutter: 10
	    }); 
	    self.$grid.imagesLoaded().progress( function() {
		  self.$grid.masonry('layout');
		});

	    $('[data-toggle="tooltip"]').tooltip();
	    self.initLoadMore();

	}
}