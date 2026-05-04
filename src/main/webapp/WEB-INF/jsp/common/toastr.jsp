<script>
    window.onload = function () {
        var msg = "${message}";
        if (msg) {
            if (msg.includes("Success") || msg.includes("successfully")) {
                toastr.success(msg);
            } else if (msg.includes("Failure") || msg.includes("Error")) {
                toastr.error(msg);
            } else {
                toastr.info(msg);
            }
        }

        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "positionClass": "toast-top-right",
            "showDuration": "300",
            "hideDuration": "1000",
            "timeOut": "5000",
            "extendedTimeOut": "1000",
            "showEasing": "swing",
            "hideEasing": "linear",
            "showMethod": "fadeIn",
            "hideMethod": "fadeOut"
        };
    };
</script>