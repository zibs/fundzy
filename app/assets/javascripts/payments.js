$(document).ready(function(){
  var pk =  $("meta[name='stripe-publishable-key']").attr("content");
  Stripe.setPublishableKey(pk);

  $("#payment-form").on("submit", function(event){
    event.preventDefault();
    // disables the button
    $("#stripe-error-message").addClass("hidden-md-up");
    $("#payment-form").find("input:submit").attr("disabled", true);
    Stripe.card.createToken($("#payment-form"), stripeResponseHandler);
  });

  var stripeResponseHandler = function(status, data) {
    if (status === 200) {
      var token = data.id;
      $("#stripe_token").val(token);
      $("#server-form").submit();
    }
    else {
      var errorMessage = data.error.message;
      $("#stripe-error-message").html(errorMessage);
      $("#stripe-error-message").removeClass("hidden-md-up");
      $("#payment-form").find("input:submit").attr("disabled", false);

    }
  };
});
