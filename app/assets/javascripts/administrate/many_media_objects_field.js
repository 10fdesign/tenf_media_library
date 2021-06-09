$(document).ready( function (e) {
  $(".field-unit--many-media-field .select-image").click( function (e) {
    e.preventDefault();
    var parent = $(this).closest('.field-unit--many-media-field');
    var modal = parent.find('.image-modal').first();
    var image_display = parent.find('.listing-images'); // should probably be renamed, though it is a 'list' of images
    var modal_image_display = parent.find('.modal-images');
    var select = parent.find('select');
    
    modal.find('.modal-images .col-sm-3').each( function() { 
      var image = $(this).find('.select-media-object-input');
      var image_id = image.data('id');
      var image_style = image.data('url');
      var image_div = `<img src='${image_style};' height='100' data-image-id='${image_id}' /> `;

      var image_name = image.data('name');
      var selected = (image.is(':checked') ? ' selected="selected"' : '');
      select.append(`<option ${selected}value="${image_id}">${image_name}</option>`);

      if (selected) {
        image_display.append(image_div);
      }
    });

    modal_image_display.empty();

  });


  $(".field-unit--many-media-field .images-search-button").click( function (e) {
    var parent = $(this).closest('.field-unit--many-media-field');
    var modal_image_display = parent.find('.modal-images');
    modal_image_display.empty();
  });

  $('.field-unit--many-media-field input.images-search').on('input', function (e) {
  	var link = $(this).parent().find(".images-search-button");
  	var href = link.attr("href");
  	href = href.replace(/query=(\w*)/, "query=" + $(this).val() );
  	link.attr("href", href);
  });

	$('.field-unit--many-media-field input.images-search').on('keydown', function (e) {
		if ( e.keyCode == 13 ) {
			e.preventDefault();
	    var parent = $(this).closest('.field-unit--many-media-field');
	    var modal_image_display = parent.find('.modal-images');
	    modal_image_display.empty();

			var link = $($(this).parent().find(".images-search-button")[0]);
			$.get( link.attr('href') );
		}
	});

  $(".field-unit--many-media-field .cancel-image").click( function (e) {
    e.preventDefault();
  });


  $(".field-unit--many-media-field .add-image").click( function (e) {
    var parent = $(this).closest('.field-unit--many-media-field');
    var modal_image_display = parent.find('.modal-images');
    modal_image_display.empty();
    console.log( parent, modal_image_display );

    e.preventDefault();
  });


  // $(".field-unit--many-media-field .images-load-more").click(function (){
  //   var numberToLoad = 2;

  //   var parent = $(this).closest('.field-unit--many-media-field .image-modal');
  //   var active_count = parent.find('.tenf-image-thumbnail-column.active').length;
  //   // console.log(active_count);

  //   var target_count = (numberToLoad - active_count % numberToLoad);
  //   // console.log(target_count);
  //   var inactives = parent.find('.tenf-image-thumbnail-column:not(.active)');
  //   var target_inactives = inactives.slice(0, target_count);

  //   target_inactives.addClass('active');
  // });

  $('.new-listing-images .listing-images').sortable({
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
      		// var selected = ($(this).find('input[name="select_image"]').is(':checked') ? ' selected="selected"' : '');
      		// select.append(`<option ${selected}value="${image_id}">${image_name}</option>`);
    	});

    	select.append(options);
  	}
  });
});