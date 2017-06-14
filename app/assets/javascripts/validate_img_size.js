$(document).ready(function() {
  $("#micropost_picture").bind("change", function() {
    var size = $('.upload-picture').data('attribute');
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > size) {
      alert(I18n.t("microposts.create.max_file_size"));
    }
  });
});
