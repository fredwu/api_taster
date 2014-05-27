(function() {
  if(typeof ApiTaster !== 'undefined') {
    ApiTaster.setHeaders(
        <%= JSON(headers.collect {|header, value|
          {key: header, value: value}
        }).html_safe
        %>
    );
  }
}).apply({});
