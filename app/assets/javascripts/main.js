$(document).ready(function(){
	//create post page
	if($('#create_post').length > 0)
	{

	}

	$('.datetimepicker').datetimepicker();
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
	    window.a = self.$grid = $('#con').masonry({
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