function previewFile(name, id) {
  var preview = document.querySelector('img[name="' + name + '"]');//どこでプレビューするか指定。'img[name="preview"]'などにすればimg複数あっても指定できます。
  var file    = document.querySelector(id).files[0];//'input[type=file]'で投稿されたファイル要素の0番目を参照します。input[type=file]にmutipleがなくてもこのコードになります。
  var reader  = new FileReader();

  reader.addEventListener("load", function () {
    preview.src = reader.result;
  }, false);

  if (file) {
    reader.readAsDataURL(file);//ここでreaderのメソッドに引数としてfileを入れます。ここで、readerのaddEventListenerが発火します。
  } else {
    $('img[name="' + name + '"]')[0].src = ""//何も選択されなかったらプレビュー空白にする
  }
}