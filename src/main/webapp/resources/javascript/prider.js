(function( $ ) {
    $.widget( "custom.combobox", {
        _create: function() {
            this.wrapper = $( "<span>" )
                .addClass( "custom-combobox" )
                .insertAfter( this.element );

            this.element.hide();
            this._createAutocomplete();
            this._createShowAllButton();
        },

        _createAutocomplete: function() {
            var selected = this.element.children( ":selected" ),
                value = selected.val() ? selected.text() : "";

            this.input = $( "<input>" )
                .appendTo( this.wrapper )
                .val( value )
                .attr( "title", "" )
                .addClass( "custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left" )
                .autocomplete({
                    delay: 0,
                    minLength: 0,
                    source: $.proxy( this, "_source" )
                })
                .tooltip({
                    tooltipClass: "ui-state-highlight"
                });

            this._on( this.input, {
                autocompleteselect: function( event, ui ) {
                    ui.item.option.selected = true;
                    this._trigger( "select", event, {
                        item: ui.item.option
                    });
                },

                autocompletechange: "_removeIfInvalid"
            });
        },

        _createShowAllButton: function() {
            var input = this.input,
                wasOpen = false;

            $( "<a>" )
                .attr( "tabIndex", -1 )
                .attr( "title", "Show All Items" )
                .tooltip()
                .appendTo( this.wrapper )
                .button({
                    icons: {
                        primary: "ui-icon-triangle-1-s"
                    },
                    text: false
                })
                .removeClass( "ui-corner-all" )
                .addClass( "custom-combobox-toggle ui-corner-right" )
                .mousedown(function() {
                    wasOpen = input.autocomplete( "widget" ).is( ":visible" );
                })
                .click(function() {
                    input.focus();

                    // Close if already visible
                    if ( wasOpen ) {
                        return;
                    }

                    // Pass empty string as value to search for, displaying all results
                    input.autocomplete( "search", "" );
                });
        },

        _source: function( request, response ) {
            var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
            response( this.element.children( "option" ).map(function() {
                var text = $( this ).text();
                if ( this.value && ( !request.term || matcher.test(text) ) )
                    return {
                        label: text,
                        value: text,
                        option: this
                    };
            }) );
        },

        _removeIfInvalid: function( event, ui ) {

            // Selected an item, nothing to do
            if ( ui.item ) {
                return;
            }

            // Search for a match (case-insensitive)
            var value = this.input.val(),
                valueLowerCase = value.toLowerCase(),
                valid = false;
            this.element.children( "option" ).each(function() {
                if ( $( this ).text().toLowerCase() === valueLowerCase ) {
                    this.selected = valid = true;
                    return false;
                }
            });

            // Found a match, nothing to do
            if ( valid ) {
                return;
            }

            // Remove invalid value
            this.input
                .val( "" )
                .attr( "title", value + " didn't match any item" )
                .tooltip( "open" );
            this.element.val( "" );
            this._delay(function() {
                this.input.tooltip( "close" ).attr( "title", "" );
            }, 2500 );
            this.input.data( "ui-autocomplete" ).term = "";
        },

        _destroy: function() {
            this.wrapper.remove();
            this.element.show();
        }
    });
})( jQuery );

$(document).ready(function() {

    // set the search box content
    $('[id="local-searchbox"]').val($('[id="query"]').html());

    if($('[id="noresults"]').size()){
        $('body').addClass('noresults');
    }

//    $( "#combobox" ).combobox();
//    $( "#toggle" ).click(function() {
//        $( "#combobox" ).toggle();
//    });

    // define jQuery UI combo-box elements
//    $( "#filter-field" ).combobox();
    $("#filter-field").change(function() {
        $( "#title-filter" ).hide();
        $( "#species-filter" ).hide();
        $( "#tissue-filter" ).hide();
        $( "#disease-filter" ).hide();
        $( "#ptm-filter" ).hide();
        $( "#instrument-filter" ).hide();
        $( "#quantification-filter" ).hide();
        $( "#exptype-filter" ).hide();
        $( "#tag-filter" ).hide();
        $( "#submtype-filter" ).hide();
        var selected = $(this).val();
        $('#'+selected).show();
    });
//    $( "#title-filter" ).hide();
//    $( "#species-filter" ).hide();
//    $( "#tissue-filter" ).hide();
//    $( "#disease-filter" ).hide();
//    $( "#ptm-filter" ).hide();
//    $( "#instrument-filter" ).hide();
//    $( "#quantification-filter" ).hide();
//    $( "#exptype-filter" ).hide();
    var selected = $("#filter-field").val();
    $('#'+selected).show();


});

//responsive table style
$(function () {
    $('table').footable({
        breakpoints: {
            phone: 750,
            tablet: 960
        }
    });
});

$(document).tooltip();

$(function () {
    $('#show-password').click(function() {
        if ($(this).is(':checked')) {
            $("#j_password").attr("type", "text");
        } else {
            $("#j_password").attr("type", "password");
        }
    })
});



function cleanLoginPassword(){
    var elem = document.getElementById("j_password");
    var password = elem.value;
    //alert('before: "' + password + '"');
    password = password.trim();
    elem.value = password;
    //alert('after: "' + password + '"');
    password = 'foo'; // don't keep the password in memory
    return true;
}

