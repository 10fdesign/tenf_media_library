$(document).ready( function (e) {
  $(".field-unit--one-image-field .select-image").click( function (e) {
    e.preventDefault();

    console.log('select-image one');
    var parent = $(this).closest('.field-unit--one-image-field ');
    // var image_id = parent.find("input.select-image-input:checked").data("id");
    var image_id = $("input.select-image-input:checked").data("id");
    if ( parent.find('select option[value=' + image_id + ']').length == 0 ) {
    	parent.find('select').append('<option value="' + image_id + '"></option>');	
    }
    parent.find('select').val( image_id );

    var image_url = $("input.select-image-input:checked").data("url");
    var image_div = `<img src='${image_url};' height='100' /> `;
    parent.find(".listing-images").empty();
    parent.find(".listing-images").append(image_div);
  });

  $(".field-unit--one-image-field .remove-image").click( function (e) {
    console.log('remove-image one');
    e.preventDefault();
    var parent = $(this).closest('.field-unit');
    parent.find('select').val('');
    parent.find(".listing-images").empty();
    parent.find(".listing-images").append('<p>No image</p>');
  });

  $(".field-unit--one-image-field .cancel-image").click( function (e) {
    console.log('cancel-image one');
    e.preventDefault();
  });

  $(".field-unit--one-image-field .add-image").click( function (e) {
    var parent = $(this).closest('.field-unit--one-image-field');
    console.log('add-image one', parent);

    e.preventDefault();
    parent.find(".modal-images").empty();
  });

  $(".field-unit--one-image-field .images-search-button").click( function (e) {
    var parent = $(this).closest('.field-unit--one-image-field');
    var modal_image_display = parent.find('.modal-images');
    modal_image_display.empty();
  });

  $('.field-unit--one-image-field input.images-search').on('input', function (e) {
  	var link = $(this).parent().find(".images-search-button");
  	var href = link.attr("href");
  	href = href.replace(/query=(\w*)/, "query=" + $(this).val() );
  	link.attr("href", href);
  });

	$('.field-unit--one-image-field input.images-search').on('keydown', function (e) {
		if ( e.keyCode == 13 ) {
			e.preventDefault();
	    var parent = $(this).closest('.field-unit--one-image-field');
	    var modal_image_display = parent.find('.modal-images');
	    modal_image_display.empty();

			var link = $($(this).parent().find(".images-search-button")[0]);
			$.get( link.attr('href') );
		}
	});

  $(".field-unit--one-image-field .images-load-more").click(function (){
    var numberToLoad = 2;

    var parent = $(this).closest('.field-unit--one-image-field .image-modal');
    var active_count = parent.find('.tenf-image-thumbnail-column.active').length;
    console.log(active_count);

    var target_count = (numberToLoad - active_count % numberToLoad);
    console.log(target_count);
    var inactives = parent.find('.tenf-image-thumbnail-column:not(.active)');
    var target_inactives = inactives.slice(0, target_count);

    target_inactives.addClass('active');
  });
});