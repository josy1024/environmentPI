// https://developer.mozilla.org/en/using_xmlhttprequest

// http://web.archive.org/web/20071103070418/http://mgran.blogspot.com/2006/08/downloading-binary-streams-with.html
function getBinary(file){
	var xhr = new XMLHttpRequest();  
	xhr.open("GET", file, false);  
	xhr.overrideMimeType("text/plain; charset=x-user-defined");  
	xhr.send(null);
	return xhr.responseText;
}

function sendBinary(data, url){
	var xhr = new XMLHttpRequest();
	xhr.open("POST", url, true);

	if (typeof XMLHttpRequest.prototype.sendAsBinary == "function") { // Firefox 3 & 4
		var tmp = '';
		for (var i = 0; i < data.length; i++) tmp += String.fromCharCode(data.charCodeAt(i) & 0xff);
		data = tmp;
	}
	else { // Chrome 9
		// http://javascript0.org/wiki/Portable_sendAsBinary
		XMLHttpRequest.prototype.sendAsBinary = function(text){
			var data = new ArrayBuffer(text.length);
			var ui8a = new Uint8Array(data, 0);
			for (var i = 0; i < text.length; i++) ui8a[i] = (text.charCodeAt(i) & 0xff);

			var bb = new BlobBuilder(); // doesn't exist in Firefox 4
			bb.append(data);
			var blob = bb.getBlob();
			this.send(blob);
		}
	}

	xhr.sendAsBinary(data);	
}

var data = getBinary("test.pdf");
sendBinary(data, "save.php");
