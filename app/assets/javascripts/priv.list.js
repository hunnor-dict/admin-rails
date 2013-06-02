function loadLetters(lang) {
	if (lang == "nb") {
		letters = {"a": "A", "b": "B", "c": "C", "d": "D", "e": "E", "f": "F", "g": "G", "h": "H", "i": "I", "j": "J", "k": "K", "l": "L", "m": "M", "n": "N", "o": "O", "p": "P", "q": "Q", "r": "R", "s": "S", "t": "T", "u": "U", "v": "V", "w": "W", "x": "X", "y": "Y", "z": "Z", "ae": "Æ", "oe": "Ø", "aa": "Å"}
	} else {
		letters = {"a": "A-Á", "b": "B", "c": "C", "cs": "CS", "d": "D", "dz": "DZ", "dzs": "DZS", "e": "E-É", "f": "F", "g": "G", "gy": "GY", "h": "H", "i": "I-Í", "j": "J", "k": "K", "l": "L", "ly": "LY", "m": "M", "n": "N", "ny": "NY", "o": "O-Ó", "oe": "Ö-Ő", "p": "P", "q": "Q", "r": "R", "s": "S", "sz": "SZ", "t": "T", "ty": "TY", "u": "U-Ú", "ue": "Ü-Ű", "v": "V", "w": "W", "x": "X", "y": "Y", "z": "Z", "zs": "ZS"}
	}
	$('#letter option').each(function(i, option) {
		$(option).remove();
	});
	$.each(letters, function(key, value) {
		$('#letter')
		.append($('<option>', { value : key })
		.text(value));
	});
}
function listLetter(lang, letter, term) {
	var listURL = "/priv/list?lang=" + lang;
	if (term == "") {
		listURL += "&letter=" + letter;
	} else {
		listURL += "&term=" + encodeURI(term);
	}
	if ($("#stat").is(":checked")) {
		listURL += "&stat=1";
	}
	$("#priv-list-results").html("Várj...");
	$.ajax({
		url: listURL,
		success: function(result) {
			$("#priv-list-results").html(result);
		},
		error: function(request, status, error) {
			$("#priv-list-results").html("Hiba.");
		}
	});
}

function loadEntry(lang, id, term) {
	var entryURL = "/priv/edit?lang=" + lang + "&id=" + id;
	if (id == "N") {
		if (term != "") {
			entryURL += "&term=" + encodeURI(term);
		}
	}
	$.ajax({
		url: entryURL,
		success: function(result) {
			$("#priv-edit-form-container").html(result);
			initForm();
			initTrans();
		},
		error: function(request, status, error) {
			$("#priv-edit").html("Hiba.");
		}
	});
}

