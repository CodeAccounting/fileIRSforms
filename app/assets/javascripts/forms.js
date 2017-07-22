$('.forms.show').ready( function() { 
    if($('#label').val() == 'other'){
           $('#label-other-container').show();
       }
    var labelname = $('#label').val().replace(/ /g, '');
    $('#color-'+labelname).show();
    var color = $('#color-'+labelname).css("background-color");
    $('#label-color').val(color);

    $('#label').change(function(){
       if($(this).val() == 'other'){ //'.val()'
           $('#label-other-container').show();
       }
       else {
         $('#label-other-container').hide();      
       }

       var labelname = $('#label').val().replace(/ /g, '');
       $('.color-box').hide();
       $('#color-'+labelname).show();
       var color = $('#color-'+labelname).css("background-color");
       $('#label-color').val(color);

    });

    $( "#form-type" ).on('change', function() {
        var form_name = $('#form-type').val();
        window.location.href = '/form/show/'+form_name;
     });

    //colorpicker
     $('#cp4').colorpicker(); /*.on('changeColor', function(e) {
            $('#cp4')[0].style.backgroundColor = e.color.toString(
                'rgba');
            $('#label-color').val(e.color.toString(
                'rgba'));
     });*/
     
     

});

