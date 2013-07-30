var _sample = {};

function sample(name) {
  var element = document.getElementsByName(name)[0];
  if (element && element.value === '') {
    element.value = _sample[name];
    element.focus();
  }
}

function filter(value, name) {
  var ul = document.getElementById(name);
  if (ul) {
    var lis = ul.getElementsByTagName('li');
    for (var i = 0, l = lis.length; i < l; i++) {
      var li = lis[i];
      var a  = li.getElementsByTagName('a')[0];
      if (a) {
        var t = a.innerHTML + '|' + a.href.split('/').pop();
        li.style.display = t.toLowerCase().indexOf(value.toLowerCase()) < 0 ? 'none' : '';
      }
    }
  }
}
