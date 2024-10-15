<!DOCTYPE html>
<html>
    <head>
    <meta name="robots" content="noindex,nofollow">
	<style type="text/css">
body {
    background: #daeeef;
}
.wptangtoc{
background-image: url("https://wptangtoc.com/share/build-ols.png");
    max-width: 512px;
    height: 512px;
    margin-left: auto;
    margin-right: auto;
    display: block;
    margin-top: 5%;
}

.image {
    box-shadow: rgba(0, 0, 0, 0.25) 0px 54px 55px, rgba(0, 0, 0, 0.12) 0px -12px 30px, rgba(0, 0, 0, 0.12) 0px 4px 6px, rgba(0, 0, 0, 0.17) 0px 12px 13px, rgba(0, 0, 0, 0.09) 0px -3px 5px;
    padding: 10px 20px;
    color: #000;
    text-align: center;
    display: block;
    background: #fff;
    border-radius: 100px;
    border: 1px solid #ccc;
    margin-left: 220px;
    position: absolute;
    margin-top: 17px;
    margin-right: auto;
}

span#hostname {
    font-size: 23px;
    text-align: center;
    margin-left: auto;
    margin-right: auto;
    display: block;
    position: relative;
}
    </style>
    </head>
<body>
<div class="wptangtoc">
<div class='image'>
<span id="hostname">Hostname.one</span>
</div>
</div>
<script type="text/javascript">
var element = document.getElementById("hostname");
element.textContent = document.location.hostname;
var a = element.textContent.length; //Biến a sẽ có giá trị là 23
console.log(a);
if ( a < 12 ){
  var style = document.createElement('style');
  style.innerHTML = `
	  .image {
    padding: 10px 57px;
}
  `;
  document.head.appendChild(style);
}

if ( a < 16 ){
  var style = document.createElement('style');
  style.innerHTML = `
	  .image {
    padding: 10px 50px;
}
  `;
  document.head.appendChild(style);
} else if ( a < 20 ){
  var style = document.createElement('style');
  style.innerHTML = `
	  .image {
    padding: 10px 40px;
}
  `;
  document.head.appendChild(style);
} else if ( a > 27 ){
  var style = document.createElement('style');
  style.innerHTML = `
	  .image {
    padding: 10px 20px !important;
}
  `;
  document.head.appendChild(style);
}

</script>
</body>
</html>
