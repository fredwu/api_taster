var ApiTaster = {

  formAction: '',

  disableSubmitButton: function() {
    $("#submit-api").attr("disabled", true);
  },

  enableSubmitButton: function() {
    $("#submit-api").attr("disabled", false);
  },

  disableUrlParams: function() {
    $("fieldset[ref=url-params] input").prop("disabled", true);
  },

  enableUrlParams: function() {
    $("fieldset[ref=url-params] input").prop("disabled", false);
  },

  storeFormActionFor: function(form) {
    ApiTaster.formAction = form.attr("action")
  },

  restoreFormActionFor: function(form) {
    $(form).attr("action", ApiTaster.formAction);
  },

  detectContentType: function(response) {
    var contentType = response.getResponseHeader("Content-Type");
    var detectedContentType = null

    if (contentType.match(/application\/json/)) {
       detectedContentType = 'json';
    }

    return detectedContentType;
  }

};

$.fn.extend({

  replaceUrlParams: function(params) {
    var form = this;

    ApiTaster.storeFormActionFor(form);

    var formAction = form.attr("action");

    $.each(params, function(i, param) {
      var matches = param["name"].match(/\[api_taster_url_params\](.*)/)
      if (matches) {
        var paramKey   = matches[1];
        var paramValue = param["value"];
        var regex      = new RegExp(":" + paramKey);

        formAction = formAction.replace(regex, paramValue);
      }
    });

    form.attr("action", formAction);
  },

  enableNavTabsFor: function(contentElement) {
    var container = this;

    $("ul.nav-tabs a", container).click(function(e) {
      e.preventDefault();

      $(this).parent().siblings().removeClass("active");
      $(this).parent().addClass("active");

      $(contentElement, container).hide();
      $(contentElement + "[ref=" + $(this).attr("id") + "]", container).show();
    });
  },

  showNavTab: function(name) {
    $("ul.nav-tabs li", this).removeClass("active");
    $("ul.nav-tabs li a#response-" + name, this).parent().show().addClass("active");

    $("pre", this).hide();

    return $("pre[ref=response-" + name + "]", this).show();
  },

  displayOnlySelectedParamsFieldset: function() {
    $("fieldset", this).hide();
    $("fieldset[ref=" + $("ul.nav-tabs li.active a").attr("id") + "]", this).show();
  }

});

jQuery(function($) {
  $("#list-api-div a").click(function(e) {
    e.preventDefault();

    $(this).parent().siblings().removeClass("active");
    $(this).parent().addClass("active");

    $("#show-api-div .div-container").load(this.href, function() {
      prettyPrint();

      $("#show-api-div form").enableNavTabsFor("fieldset");
      $("#show-api-div form").displayOnlySelectedParamsFieldset();
    });
  });

  $("#show-api-div").on("click", "#submit-api", function() {
    $(this).parents("form").submit(function() {
      ApiTaster.disableSubmitButton();

      $(this).unbind("submit").ajaxSubmit({
        beforeSubmit: function(arr, $form, options) {
          $form.replaceUrlParams(arr);
          ApiTaster.disableUrlParams();
          return false;
        }
      });
    });

    $("form").bind("ajax:complete", function(e, xhr, status) {
      ApiTaster.enableSubmitButton();
      ApiTaster.enableUrlParams();
      ApiTaster.restoreFormActionFor(this);

      if ($("#show-api-response-div:visible").length == 0) {
        $("#show-api-response-div").slideDown(100);
      }

      switch (ApiTaster.detectContentType(xhr)) {
        case "json":
          $("#show-api-response-div").showNavTab("json").text(
            JSON.stringify(JSON.parse(xhr.responseText), null, 2)
          );
          break;
      }

      $("#show-api-response-div pre[ref=response-raw]").text(xhr.responseText);

      prettyPrint();
    });

    $("#show-api-response-div").enableNavTabsFor("pre");
  });
});

