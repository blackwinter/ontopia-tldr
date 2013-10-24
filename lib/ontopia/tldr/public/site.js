var _sample = {}, _style;

function sample(name) {
  var element = document.getElementsByName(name)[0];
  if (element && element.value === '') {
    element.value = _sample[name];
    element.focus();
  }
}

function filter1(value, name) {
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

/* http://redotheweb.com/2013/05/15/client-side-full-text-search-in-css.html */
function filter2(value, name) {
  if (!_style) {
    _style = document.createElement('style');
    document.head.appendChild(_style);
  }

  _style.innerHTML = value ? '#' + name + ' li:not([data-index*="' + value.toLowerCase() + '"]) { display: none; }' : '';
}

var filter = filter1;
