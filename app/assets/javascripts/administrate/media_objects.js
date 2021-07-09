// $(document).ready( function (e) {
function setup_media_library_modal() {

  $(".image-modal .select-image").off('click').click( function (e) {
    e.preventDefault();
    var parent = $( $(this).data('parent-selector') );
    var modal = $('.image-modal').first();
    var image_display = parent.find('.listing-images'); // should probably be renamed, though it is a 'list' of images
    var modal_image_display = parent.find('.modal-images');
    var select = parent.find('select');
    
		if ( parent.parent(".field-unit").hasClass("field-unit--single-media-field") ) {
			image_display.empty();
		}

    modal.find('.modal-images .col-sm-3').each( function() { 
      var image = $(this).find('.select-media-object-input');
      var image_id = image.data('id');
      var image_style = image.data('url');
      var image_div = `<div class="media-thumbnail-container"><img src='${image_style};' height='100' data-image-id='${image_id}' /><a class="btn btn-sm btn-danger media-object-remove" data-id="${image_id}"><i class="fas fa-times"></i></a></div>`;

      var image_name = image.data('name');
      var selected = (image.is(':checked') ? ' selected="selected"' : '');
      select.append(`<option ${selected}value="${image_id}">${image_name}</option>`);

      if (selected) {
        image_display.append(image_div);
      }
      $(".media-object-remove").click( remove_media_object );

    });

    modal_image_display.empty();
  });

  var remove_media_object = function (e) {
  	e.preventDefault();
  	var parent = $(this).closest(".field-unit");
  	var select = parent.find("select");
  	var image_id = $(this).data("id");
  	select.find("option[value=" + image_id + "]").attr("selected", false);
  	$(this).closest(".media-thumbnail-container").remove();
  }

  $(".media-object-remove").click( remove_media_object );

  $(".images-search-button").off('click').click( function (e) {
    $('.modal-images').empty();
  });

  $('input.images-search').off('input').on('input', function (e) {
  	var link = $(".images-search-button");
  	var href = link.attr("href");
  	href = href.replace(/search=(.*)/, "search=" + $(this).val() );
  	link.attr("href", href);
  });

	$('input.images-search').off('keyup').on( 'keyup', function (e) {
		if ( e.keyCode == 13 ) {
			e.preventDefault();
	    $('.modal-images').empty();

			var link = $(".images-search-button");
			$.get( link.attr('href'), { format: "js" } );
		}
	});

  $('.field-unit--many-media-field .new-listing-images .listing-images').sortable({
  	update: function( event, ui ) {
  		console.log("updating!");
    	var parent = $(this).closest('.field-unit--many-media-field');

    	var select = parent.find('select');
    	var options = select.find('option');


    	var images = parent.find('.listing-images img');

    	select.empty();

    	images.each(function(index) {
    		var image_id = $(this).data('image-id');

    		// console.log($(this));
    		var match = options.filter(function(i) {
    			// console.log($(this).val(), index+1);
    			return parseInt($(this).val()) === image_id;
    			// return true;
    		});

    		options = options.filter(function(i) {
    			return parseInt($(this).val()) != image_id;
    		})


    		select.append(match);
    	});

    	select.append(options);
  	}
  });
};

setup_media_library_modal();