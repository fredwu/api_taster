var ApiTaster = {
	formAction: '',
	disableUrlParams: function() {
		$("#url-params input").prop("disabled", true);
	},
	enableUrlParams: function() {
		$("#url-params input").prop("disabled", false);
	},
	storeFormActionFor: function(form) {
		ApiTaster.formAction = form.attr("action")
	},
	restoreFormActionFor: function(form) {
		$(form).attr("action", ApiTaster.formAction);
	}
};

$.fn.extend({
	replaceUrlParams: function(params) {
		var form = this;

		$.each(params, function(i, param) {
			var matches = param["name"].match(/\[api_taster_url_params\](.*)/)
			if (matches) {
				var paramKey   = matches[1];
				var paramValue = param["value"];

				ApiTaster.storeFormActionFor(form);

				var regex = new RegExp(":" + paramKey);
				var replacedAction = ApiTaster.formAction.replace(regex, paramValue);

				form.attr("action", replacedAction);
			}
		});
	}
});

jQuery(function($) {
	$("a.show-api").click(function(e) {
		e.preventDefault();

		$("a.show-api").parent().removeClass("active");
		$(this).parent().addClass("active");

		$("#show-api-div").load(this.href, function() {
			prettyPrint();
		});
	});

	$("#show-api-div").on("click", "#submit-api", function() {
		$(this).parents("form").submit(function() {
			$(this).unbind("submit").ajaxSubmit({
				beforeSubmit: function(arr, $form, options) {
					$form.replaceUrlParams(arr);
					ApiTaster.disableUrlParams();
					return false;
				}
			});
		});

		$("form").bind("ajax:complete", function(e, xhr, status) {
			ApiTaster.enableUrlParams();
			ApiTaster.restoreFormActionFor(this);

			if ($("#show-api-response-div:visible").length == 0) {
				$("#show-api-response-div").slideDown(100);
			}

			$("#show-api-response-div pre[ref=response-raw]").text(xhr.responseText);
			$("#show-api-response-div pre[ref=response-json]").text(
				JSON.stringify(JSON.parse(xhr.responseText), null, 2)
			);

			prettyPrint();
		});

		$("#show-api-response-div ul.nav-tabs a").click(function(e) {
			e.preventDefault();

			$(this).parent().siblings().removeClass("active");
			$(this).parent().addClass("active");

			$("pre", "#show-api-response-div").hide();
			$("pre[ref=" + $(this).attr("id") + "]", "#show-api-response-div").show();
		});
	});
});

